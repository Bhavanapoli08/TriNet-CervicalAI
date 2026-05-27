const CLASS_NAMES = [
  'Dyskeratotic',
  'Koilocytotic',
  'Metaplastic',
  'Parabasal',
  'Superficial-Intermediate',
];

const RISK = {
  'Dyskeratotic': 'high',
  'Koilocytotic': 'high',
  'Metaplastic': 'medium',
  'Parabasal': 'low',
  'Superficial-Intermediate': 'low',
};

const DEFAULT_WEIGHTS = { resnet50: 0.40, densenet121: 0.38, efficientnet_b3: 0.22 };

const dropZone = document.getElementById('dropZone');
const fileInput = document.getElementById('fileInput');
const preview = document.getElementById('preview');
const analyzeBtn = document.getElementById('analyzeBtn');
const clearBtn = document.getElementById('clearBtn');
const resultsCol = document.getElementById('resultsCol');
const predClass = document.getElementById('predClass');
const predCategory = document.getElementById('predCategory');
const riskBadge = document.getElementById('riskBadge');
const confidenceEl = document.getElementById('confidence');
const barsContainer = document.getElementById('barsContainer');
const perModel = document.getElementById('perModel');
const spinner = document.getElementById('spinner');
const analyzeText = document.getElementById('analyzeText');
const toast = document.getElementById('toast');
const interactiveWeights = document.getElementById('interactiveWeights');

let selectedFile = null;
let lastServerData = null;

function showToast(msg) {
  toast.textContent = msg;
  toast.classList.remove('hidden');
  setTimeout(() => toast.classList.add('hidden'), 4000);
}

function reset() {
  selectedFile = null;
  fileInput.value = '';
  preview.src = '';
  preview.classList.add('hidden');
  analyzeBtn.disabled = true;
  resultsCol.classList.add('hidden');
}

dropZone.addEventListener('click', () => fileInput.click());
dropZone.addEventListener('keydown', (e) => { if (e.key === 'Enter') fileInput.click(); if (e.key === 'Escape') reset(); });

fileInput.addEventListener('change', (e) => {
  const f = e.target.files[0];
  selectFile(f);
});

function selectFile(f) {
  if (!f) return reset();
  const allowed = ['image/jpeg','image/png','image/bmp'];
  if (!allowed.includes(f.type)) { showToast('Only JPG, PNG, BMP images allowed'); return; }
  if (f.size > 10 * 1024 * 1024) { showToast('File too large (max 10MB)'); return; }
  selectedFile = f;
  const url = URL.createObjectURL(f);
  preview.src = url;
  preview.classList.remove('hidden');
  analyzeBtn.disabled = false;
}

dropZone.addEventListener('dragover', (e) => { e.preventDefault(); dropZone.classList.add('ring-2'); });
dropZone.addEventListener('dragleave', () => { dropZone.classList.remove('ring-2'); });
dropZone.addEventListener('drop', (e) => {
  e.preventDefault(); dropZone.classList.remove('ring-2');
  const f = e.dataTransfer.files[0];
  selectFile(f);
});

clearBtn.addEventListener('click', reset);

analyzeBtn.addEventListener('click', async () => {
  if (!selectedFile) return;
  analyzeBtn.disabled = true;
  spinner.classList.remove('hidden');
  analyzeText.textContent = 'Analyzing';
  barsContainer.innerHTML = '';
  perModel.innerHTML = '';
  interactiveWeights.innerHTML = '';
  resultsCol.classList.add('hidden');

  const fd = new FormData();
  fd.append('file', selectedFile);

  try {
    const res = await fetch('/predict', { method: 'POST', body: fd });
    if (!res.ok) {
      const err = await res.json().catch(() => null);
      throw new Error(err?.detail || 'Server error');
    }
    const data = await res.json();
    lastServerData = data;
    renderResults(data);
  } catch (err) {
    console.error(err);
    showToast(err.message || 'Prediction failed');
  } finally {
    spinner.classList.add('hidden');
    analyzeText.textContent = 'Analyze';
    analyzeBtn.disabled = false;
  }
});

function renderResults(data) {
  // initial display uses server fused result
  updateHero(data.predicted_class, data.category, data.risk_level, data.confidence);
  renderBars(data.all_probabilities);
  renderPerModelTable(data.per_model_probabilities);
  buildInteractiveWeights(data.per_model_probabilities);
  resultsCol.classList.remove('hidden');
  resultsCol.classList.add('fade-in');
}

function updateHero(predicted_class, category, risk_level, confidence) {
  predClass.textContent = predicted_class;
  predCategory.textContent = `${category} · ${risk_level}`;
  confidenceEl.textContent = `${(confidence * 100).toFixed(1)}%`;

  riskBadge.className = 'inline-flex items-center px-3 py-1 rounded-full font-medium';
  if (risk_level === 'low') { riskBadge.classList.add('risk-low'); riskBadge.textContent = 'Normal · Low risk'; }
  else if (risk_level === 'medium') { riskBadge.classList.add('risk-medium'); riskBadge.textContent = 'Benign · Medium risk'; }
  else { riskBadge.classList.add('risk-high'); riskBadge.textContent = 'Abnormal · High risk · Refer to gynecologist'; }
}

function renderBars(all_probs) {
  barsContainer.innerHTML = '';
  for (const cls of CLASS_NAMES) {
    const pct = (all_probs[cls] || 0) * 100;
    const barWrap = document.createElement('div');
    barWrap.className = 'flex items-center gap-3';
    barWrap.innerHTML = `
      <div class="w-56 text-sm text-gray-700">${cls}</div>
      <div class="flex-1">
        <div class="bar-bg"><div class="bar-fill" data-pct="${pct}"></div></div>
      </div>
      <div class="w-20 text-right text-sm font-medium">${pct.toFixed(1)}%</div>
    `;
    barsContainer.appendChild(barWrap);
  }

  requestAnimationFrame(() => {
    document.querySelectorAll('.bar-fill').forEach(el => {
      const pct = el.getAttribute('data-pct');
      el.style.width = pct + '%';
      const cls = el.parentElement.parentElement.querySelector('.w-56').textContent.trim();
      const r = RISK[cls];
      if (r === 'low') el.classList.add('risk-low');
      else if (r === 'medium') el.classList.add('risk-medium');
      else el.classList.add('risk-high');
    });
  });
}

function renderPerModelTable(per_model_probs) {
  perModel.innerHTML = `
    <table class="w-full text-sm mt-3">
      <thead class="text-left text-xs text-gray-500"><tr><th>Model</th><th>Weight</th><th>Top prediction</th><th>Confidence</th></tr></thead>
      <tbody id="modelRows"></tbody>
    </table>
  `;
  const tbody = document.getElementById('modelRows');
  for (const [name, probs] of Object.entries(per_model_probs)) {
    let topIdx = 0; let topP = probs[CLASS_NAMES[0]] || 0;
    for (const cls of CLASS_NAMES) {
      if ((probs[cls] || 0) > topP) { topP = probs[cls]; topIdx = CLASS_NAMES.indexOf(cls); }
    }
    const row = document.createElement('tr');
    row.innerHTML = `<td class="py-2">${prettyModelName(name)}</td><td class="model-weight" data-name="${name}">${(DEFAULT_WEIGHTS[name]||0).toFixed(2)}</td><td>${CLASS_NAMES[topIdx]}</td><td>${(topP*100).toFixed(1)}%</td>`;
    tbody.appendChild(row);
  }
}

function buildInteractiveWeights(per_model_probs) {
  interactiveWeights.innerHTML = '';
  const title = document.createElement('div');
  title.className = 'text-sm font-medium mb-2';
  title.textContent = 'Interactive ensemble weights — adjust to explore how the fused prediction changes';
  interactiveWeights.appendChild(title);

  const container = document.createElement('div');
  container.className = 'space-y-3';

  for (const name of Object.keys(per_model_probs)) {
    const id = `w_${name}`;
    const row = document.createElement('div');
    row.className = 'flex items-center gap-3';
    row.innerHTML = `
      <div class="w-40 text-sm">${prettyModelName(name)}</div>
      <input id="${id}" type="range" min="0" max="100" value="${Math.round((DEFAULT_WEIGHTS[name]||0)*100)}" class="flex-1">
      <div id="${id}_val" class="w-14 text-right text-sm font-medium">${Math.round((DEFAULT_WEIGHTS[name]||0)*100)}%</div>
    `;
    container.appendChild(row);
    interactiveWeights.appendChild(container);

    const slider = document.getElementById(id);
    const val = document.getElementById(`${id}_val`);
    slider.addEventListener('input', () => {
      val.textContent = `${slider.value}%`;
      recomputeFromSliders(per_model_probs);
    });
  }

  // reset button
  const resetBtn = document.createElement('button');
  resetBtn.className = 'mt-2 px-3 py-1 border rounded text-sm';
  resetBtn.textContent = 'Reset weights';
  resetBtn.addEventListener('click', () => {
    for (const name of Object.keys(per_model_probs)) {
      const id = `w_${name}`;
      const slider = document.getElementById(id);
      if (slider) slider.value = Math.round((DEFAULT_WEIGHTS[name]||0)*100);
      const val = document.getElementById(`${id}_val`);
      if (val) val.textContent = `${Math.round((DEFAULT_WEIGHTS[name]||0)*100)}%`;
    }
    recomputeFromSliders(per_model_probs);
  });
  interactiveWeights.appendChild(resetBtn);

  // initial compute
  recomputeFromSliders(per_model_probs);
}

function recomputeFromSliders(per_model_probs) {
  const names = Object.keys(per_model_probs);
  const raw = names.map(n => {
    const s = document.getElementById(`w_${n}`);
    return s ? Number(s.value) : 0;
  });
  let sum = raw.reduce((a,b) => a+b, 0);
  if (sum <= 0) { sum = names.length; raw.fill(1); }
  const weights = raw.map(v => v / sum);

  // update weight cells in table
  document.querySelectorAll('.model-weight').forEach(el => {
    const nm = el.getAttribute('data-name');
    const idx = names.indexOf(nm);
    if (idx >= 0) el.textContent = weights[idx].toFixed(2);
  });

  // compute fused probs
  const fused = {};
  for (const cls of CLASS_NAMES) fused[cls] = 0;
  names.forEach((n, i) => {
    const modelProbs = per_model_probs[n];
    for (const cls of CLASS_NAMES) {
      fused[cls] += weights[i] * (modelProbs[cls] || 0);
    }
  });

  // update bars and hero
  renderBars(fused);
  // pick top
  let top = CLASS_NAMES[0];
  for (const cls of CLASS_NAMES) if (fused[cls] > fused[top]) top = cls;
  const conf = fused[top] || 0;
  const cat = (top in RISK) ? (RISK[top] === 'high' ? 'Abnormal' : (RISK[top] === 'medium' ? 'Benign' : 'Normal')) : '';
  const risk_level = (top in RISK) ? RISK[top] : 'low';
  updateHero(top, cat, risk_level, conf);
}

function prettyModelName(key) {
  if (key === 'resnet50') return 'ResNet50';
  if (key === 'densenet121') return 'DenseNet121';
  if (key === 'efficientnet_b3') return 'EfficientNet-B3';
  return key;
}

// About modal
const aboutLink = document.getElementById('aboutLink');
const aboutModal = document.getElementById('aboutModal');
const closeAbout = document.getElementById('closeAbout');
aboutLink.addEventListener('click', (e) => { e.preventDefault(); aboutModal.classList.remove('hidden'); aboutModal.classList.add('flex'); });
closeAbout.addEventListener('click', () => { aboutModal.classList.add('hidden'); aboutModal.classList.remove('flex'); });
aboutModal.addEventListener('click', (e) => { if (e.target === aboutModal) { aboutModal.classList.add('hidden'); aboutModal.classList.remove('flex'); } });

// init
reset();
