<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Project README — CerviAI & FedSkin</title>
<style>
  :root {
    --bg: #0d0f12;
    --surface: #161a21;
    --surface2: #1e242e;
    --border: rgba(255,255,255,0.08);
    --border2: rgba(255,255,255,0.14);
    --text: #e8ecf0;
    --muted: #8892a4;
    --accent1: #4fffb0;
    --accent2: #7c8fff;
    --accent3: #ff8c6b;
    --accent4: #ffd166;
    --radius: 10px;
    --mono: 'JetBrains Mono', 'Fira Code', 'Courier New', monospace;
  }
  * { box-sizing: border-box; margin: 0; padding: 0; }
  body {
    background: var(--bg);
    color: var(--text);
    font-family: 'Georgia', 'Times New Roman', serif;
    font-size: 16px;
    line-height: 1.75;
  }
  a { color: var(--accent2); text-decoration: none; }
  a:hover { text-decoration: underline; }

  /* HERO */
  .hero {
    padding: 80px 40px 60px;
    text-align: center;
    border-bottom: 1px solid var(--border);
    position: relative;
    overflow: hidden;
  }
  .hero::before {
    content: '';
    position: absolute;
    inset: 0;
    background: radial-gradient(ellipse 80% 60% at 50% -10%, rgba(76,255,176,0.06) 0%, transparent 70%),
                radial-gradient(ellipse 60% 40% at 80% 80%, rgba(124,143,255,0.05) 0%, transparent 60%);
    pointer-events: none;
  }
  .badge-row {
    display: flex;
    justify-content: center;
    flex-wrap: wrap;
    gap: 8px;
    margin-bottom: 28px;
  }
  .badge {
    font-family: var(--mono);
    font-size: 11px;
    padding: 4px 12px;
    border-radius: 20px;
    font-weight: 500;
    letter-spacing: 0.02em;
  }
  .badge-green  { background: rgba(76,255,176,0.12); color: var(--accent1); border: 1px solid rgba(76,255,176,0.3); }
  .badge-blue   { background: rgba(124,143,255,0.12); color: var(--accent2); border: 1px solid rgba(124,143,255,0.3); }
  .badge-orange { background: rgba(255,140,107,0.12); color: var(--accent3); border: 1px solid rgba(255,140,107,0.3); }
  .badge-yellow { background: rgba(255,209,102,0.12); color: var(--accent4); border: 1px solid rgba(255,209,102,0.3); }
  .hero h1 {
    font-family: 'Georgia', serif;
    font-size: clamp(32px, 5vw, 56px);
    font-weight: 700;
    letter-spacing: -0.02em;
    line-height: 1.15;
    margin-bottom: 16px;
  }
  .hero h1 span.g { color: var(--accent1); }
  .hero h1 span.b { color: var(--accent2); }
  .hero-sub {
    color: var(--muted);
    font-size: 18px;
    max-width: 620px;
    margin: 0 auto 36px;
    font-family: 'Georgia', serif;
    line-height: 1.6;
  }
  .hero-meta {
    display: flex;
    justify-content: center;
    gap: 32px;
    flex-wrap: wrap;
    font-size: 13px;
    color: var(--muted);
    font-family: var(--mono);
  }
  .hero-meta span strong { color: var(--text); }

  /* LAYOUT */
  .container { max-width: 1040px; margin: 0 auto; padding: 0 32px; }
  section { padding: 64px 0; border-bottom: 1px solid var(--border); }
  section:last-child { border-bottom: none; }

  h2 {
    font-family: 'Georgia', serif;
    font-size: 28px;
    font-weight: 700;
    margin-bottom: 8px;
    letter-spacing: -0.01em;
  }
  h2 .accent { color: var(--accent1); }
  h2 .accent2 { color: var(--accent2); }
  h3 {
    font-size: 16px;
    font-weight: 600;
    margin-bottom: 10px;
    font-family: 'Georgia', serif;
    letter-spacing: 0.01em;
  }
  .section-intro {
    color: var(--muted);
    font-size: 15px;
    margin-bottom: 40px;
    max-width: 680px;
    line-height: 1.65;
  }

  /* CARDS GRID */
  .card-grid { display: grid; gap: 16px; }
  .card-grid-2 { grid-template-columns: repeat(auto-fit, minmax(280px, 1fr)); }
  .card-grid-3 { grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); }
  .card {
    background: var(--surface);
    border: 1px solid var(--border);
    border-radius: var(--radius);
    padding: 24px;
    transition: border-color 0.2s;
  }
  .card:hover { border-color: var(--border2); }
  .card-icon {
    font-size: 24px;
    margin-bottom: 14px;
  }
  .card p { color: var(--muted); font-size: 14px; line-height: 1.6; margin-top: 6px; }

  /* STAT CARDS */
  .stat-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(150px, 1fr)); gap: 12px; margin-top: 32px; }
  .stat-card {
    background: var(--surface);
    border: 1px solid var(--border);
    border-radius: var(--radius);
    padding: 20px 18px;
    text-align: center;
  }
  .stat-val { font-family: var(--mono); font-size: 26px; font-weight: 700; }
  .stat-val.green { color: var(--accent1); }
  .stat-val.blue { color: var(--accent2); }
  .stat-val.orange { color: var(--accent3); }
  .stat-val.yellow { color: var(--accent4); }
  .stat-label { font-size: 12px; color: var(--muted); margin-top: 4px; font-family: var(--mono); }

  /* MOCK SCREENSHOTS */
  .mock-container {
    border-radius: 14px;
    overflow: hidden;
    border: 1px solid var(--border2);
    background: var(--surface);
  }
  .mock-bar {
    background: var(--surface2);
    padding: 10px 16px;
    display: flex;
    align-items: center;
    gap: 8px;
    border-bottom: 1px solid var(--border);
  }
  .mock-dot { width: 10px; height: 10px; border-radius: 50%; }
  .d-red { background: #ff5f57; }
  .d-yellow { background: #febc2e; }
  .d-green { background: #28c840; }
  .mock-url {
    flex: 1;
    background: rgba(255,255,255,0.06);
    border-radius: 6px;
    padding: 4px 12px;
    font-size: 12px;
    font-family: var(--mono);
    color: var(--muted);
    margin-left: 8px;
  }
  .mock-body { padding: 24px; }

  /* PHONE MOCK */
  .phone-wrap {
    display: flex;
    justify-content: center;
    gap: 28px;
    flex-wrap: wrap;
  }
  .phone {
    width: 200px;
    background: #111418;
    border-radius: 36px;
    border: 2px solid rgba(255,255,255,0.15);
    padding: 16px 12px;
    box-shadow: 0 24px 48px rgba(0,0,0,0.5);
  }
  .phone-notch {
    width: 60px;
    height: 14px;
    background: #111418;
    border-radius: 0 0 10px 10px;
    margin: 0 auto 12px;
    border: 2px solid rgba(255,255,255,0.1);
    border-top: none;
  }
  .phone-screen {
    background: var(--surface);
    border-radius: 24px;
    overflow: hidden;
    min-height: 360px;
  }
  .phone-header {
    background: var(--surface2);
    padding: 10px 14px;
    font-size: 11px;
    font-weight: 600;
    border-bottom: 1px solid var(--border);
    display: flex;
    justify-content: space-between;
    align-items: center;
  }
  .phone-content { padding: 14px 12px; }

  /* WEB DASHBOARD MOCK */
  .dash-sidebar {
    width: 180px;
    background: var(--surface2);
    border-right: 1px solid var(--border);
    padding: 16px;
    flex-shrink: 0;
  }
  .dash-main { flex: 1; padding: 20px; overflow: hidden; }
  .dash-layout { display: flex; min-height: 340px; }
  .nav-item {
    font-size: 12px;
    padding: 7px 10px;
    border-radius: 6px;
    margin-bottom: 4px;
    cursor: default;
    color: var(--muted);
  }
  .nav-item.active {
    background: rgba(76,255,176,0.1);
    color: var(--accent1);
  }
  .nav-section-label {
    font-size: 10px;
    font-family: var(--mono);
    color: rgba(255,255,255,0.25);
    text-transform: uppercase;
    letter-spacing: 0.08em;
    padding: 12px 10px 4px;
  }

  /* TABLE */
  .data-table {
    width: 100%;
    border-collapse: collapse;
    font-size: 13px;
    font-family: var(--mono);
  }
  .data-table th {
    text-align: left;
    padding: 8px 12px;
    color: var(--muted);
    border-bottom: 1px solid var(--border);
    font-weight: 500;
    font-size: 11px;
    text-transform: uppercase;
    letter-spacing: 0.05em;
  }
  .data-table td {
    padding: 8px 12px;
    border-bottom: 1px solid var(--border);
    color: var(--text);
  }
  .data-table tr:last-child td { border-bottom: none; }
  .data-table tr:hover td { background: rgba(255,255,255,0.02); }
  .pill {
    display: inline-block;
    font-size: 10px;
    padding: 2px 8px;
    border-radius: 20px;
    font-family: var(--mono);
  }
  .pill-green { background: rgba(76,255,176,0.12); color: var(--accent1); }
  .pill-blue  { background: rgba(124,143,255,0.12); color: var(--accent2); }
  .pill-orange { background: rgba(255,140,107,0.12); color: var(--accent3); }

  /* CODE */
  pre {
    background: var(--surface2);
    border: 1px solid var(--border);
    border-radius: var(--radius);
    padding: 20px 24px;
    overflow-x: auto;
    font-family: var(--mono);
    font-size: 13px;
    line-height: 1.7;
    color: #c9d1d9;
  }
  code { font-family: var(--mono); font-size: 13px; }
  .kw { color: #ff7b72; }
  .str { color: #a5d6ff; }
  .cm { color: #8b949e; }
  .fn { color: #d2a8ff; }
  .num { color: #79c0ff; }
  .var { color: #ffa657; }

  /* ARCH DIAGRAM */
  .arch-box {
    background: var(--surface);
    border: 1px solid var(--border);
    border-radius: 8px;
    padding: 12px 16px;
    font-size: 13px;
    text-align: center;
  }
  .arch-box small { display: block; color: var(--muted); font-size: 11px; margin-top: 2px; font-family: var(--mono); }
  .arch-arrow { color: var(--muted); font-size: 18px; align-self: center; }
  .arch-row { display: flex; align-items: stretch; gap: 8px; margin-bottom: 8px; }
  .arch-box.green { border-color: rgba(76,255,176,0.3); }
  .arch-box.blue { border-color: rgba(124,143,255,0.3); }
  .arch-box.orange { border-color: rgba(255,140,107,0.3); }
  .arch-box.yellow { border-color: rgba(255,209,102,0.3); }

  /* DIVIDER */
  .divider-label {
    display: flex;
    align-items: center;
    gap: 16px;
    margin: 48px 0 40px;
  }
  .divider-label hr { flex: 1; border: none; border-top: 1px solid var(--border); }
  .divider-label span {
    font-family: var(--mono);
    font-size: 11px;
    color: var(--muted);
    text-transform: uppercase;
    letter-spacing: 0.1em;
    white-space: nowrap;
  }

  /* STEP */
  .steps { display: flex; flex-direction: column; gap: 16px; }
  .step { display: flex; gap: 20px; align-items: flex-start; }
  .step-num {
    width: 32px;
    height: 32px;
    border-radius: 50%;
    background: var(--surface2);
    border: 1px solid var(--border2);
    font-family: var(--mono);
    font-size: 13px;
    display: flex;
    align-items: center;
    justify-content: center;
    flex-shrink: 0;
    color: var(--accent1);
    font-weight: 700;
  }
  .step-body { padding-top: 4px; }
  .step-body h4 { font-size: 15px; margin-bottom: 4px; }
  .step-body p { font-size: 13px; color: var(--muted); }

  /* COMPARISON TABLE */
  .compare-table {
    width: 100%;
    border-collapse: collapse;
    font-size: 14px;
    margin-top: 24px;
  }
  .compare-table th {
    padding: 10px 16px;
    border-bottom: 1px solid var(--border);
    font-weight: 600;
    font-size: 13px;
    color: var(--muted);
    text-align: left;
  }
  .compare-table td {
    padding: 10px 16px;
    border-bottom: 1px solid var(--border);
  }
  .compare-table tr:last-child td { border-bottom: none; }
  .check { color: var(--accent1); }
  .cross { color: var(--accent3); }

  /* FOOTER */
  footer {
    padding: 48px 32px;
    text-align: center;
    color: var(--muted);
    font-size: 13px;
    font-family: var(--mono);
    border-top: 1px solid var(--border);
  }

  /* PROGRESS BAR */
  .progress-row { margin-bottom: 12px; }
  .progress-label { display: flex; justify-content: space-between; font-size: 12px; margin-bottom: 4px; }
  .progress-label span:first-child { color: var(--text); }
  .progress-label span:last-child { font-family: var(--mono); color: var(--accent1); }
  .progress-bar { height: 6px; background: var(--surface2); border-radius: 4px; overflow: hidden; }
  .progress-fill { height: 100%; border-radius: 4px; }
  .fill-green { background: var(--accent1); }
  .fill-blue  { background: var(--accent2); }
  .fill-orange { background: var(--accent3); }

  /* INLINE CODE */
  .ic {
    background: var(--surface2);
    border: 1px solid var(--border);
    border-radius: 4px;
    padding: 1px 6px;
    font-family: var(--mono);
    font-size: 12px;
    color: var(--accent4);
  }

  @media (max-width: 600px) {
    .hero { padding: 48px 20px 40px; }
    .container { padding: 0 20px; }
    .dash-sidebar { display: none; }
    .phone { width: 160px; }
    h2 { font-size: 22px; }
  }
</style>
</head>
<body>

<!-- ═══════════════════════ HERO ═══════════════════════ -->
<div class="hero">
  <div class="badge-row">
    <span class="badge badge-green">Deep Learning</span>
    <span class="badge badge-blue">Federated Learning</span>
    <span class="badge badge-orange">Flutter · Android · iOS</span>
    <span class="badge badge-yellow">Google Cloud Platform</span>
    <span class="badge badge-green">TensorFlow Lite</span>
    <span class="badge badge-blue">FastAPI · Docker</span>
  </div>
  <h1>
    <span class="g">CerviAI</span> &amp; <span class="b">FedSkin</span><br>
    Medical AI · Deployed
  </h1>
  <p class="hero-sub">
    Two end-to-end clinical AI systems — a cervical cancer cell classifier and a privacy-preserving federated skin lesion analyser — deployed across mobile, cloud, and web.
  </p>
  <div class="hero-meta">
    <span>Course <strong>24CS733 MAD</strong></span>
    <span>Institution <strong>Amrita School of Engineering, Bengaluru</strong></span>
    <span>May <strong>2025</strong></span>
  </div>
</div>

<!-- ═══════════════════════ TABLE OF CONTENTS ═══════════════════════ -->
<div class="container">
<section>
  <h2>📋 Table of <span class="accent">Contents</span></h2>
  <p class="section-intro">This README documents both projects end-to-end — from model architecture to deployment screenshots.</p>
  <div class="card-grid card-grid-2">
    <div class="card">
      <h3>🩺 CerviAI</h3>
      <p>Ensemble CNN for Pap smear classification · Flutter mobile app · Cloud Run REST API · Gemini chatbot</p>
      <ul style="margin-top:12px;padding-left:18px;font-size:13px;color:var(--muted);line-height:2;">
        <li><a href="#cervi-overview">Overview &amp; Goals</a></li>
        <li><a href="#cervi-model">Model Architecture</a></li>
        <li><a href="#cervi-metrics">Performance Metrics</a></li>
        <li><a href="#cervi-mobile">Mobile App Screenshots</a></li>
        <li><a href="#cervi-cloud">Cloud Deployment</a></li>
        <li><a href="#cervi-install">Installation</a></li>
      </ul>
    </div>
    <div class="card">
      <h3>🔬 FedSkin</h3>
      <p>Federated DenseNet-121 for skin lesion classification · Privacy-preserving FL · Gradio web app · Docker</p>
      <ul style="margin-top:12px;padding-left:18px;font-size:13px;color:var(--muted);line-height:2;">
        <li><a href="#fed-overview">Overview &amp; Motivation</a></li>
        <li><a href="#fed-arch">Federated Architecture</a></li>
        <li><a href="#fed-metrics">Performance Metrics</a></li>
        <li><a href="#fed-web">Web App Screenshots</a></li>
        <li><a href="#fed-install">Installation</a></li>
      </ul>
    </div>
  </div>
</section>

<!-- ═══════════════════════ CERVI OVERVIEW ═══════════════════════ -->
<section id="cervi-overview">
  <h2>🩺 CerviAI — <span class="accent">Overview</span></h2>
  <p class="section-intro">
    CerviAI automates Pap smear cervical cell classification using a weighted soft-voting ensemble of three CNNs trained on the SIPaKMeD dataset. It achieves 97.34% test accuracy and deploys as both a Flutter mobile app (offline TFLite) and a Cloud Run REST API.
  </p>

  <div class="stat-grid">
    <div class="stat-card">
      <div class="stat-val green">97.34%</div>
      <div class="stat-label">Test Accuracy</div>
    </div>
    <div class="stat-card">
      <div class="stat-val blue">0.9751</div>
      <div class="stat-label">Macro F1-score</div>
    </div>
    <div class="stat-card">
      <div class="stat-val orange">0.9984</div>
      <div class="stat-label">Macro AUC-ROC</div>
    </div>
    <div class="stat-card">
      <div class="stat-val yellow">5,015</div>
      <div class="stat-label">Training Images</div>
    </div>
    <div class="stat-card">
      <div class="stat-val green">42.7 MB</div>
      <div class="stat-label">Deployed Model</div>
    </div>
    <div class="stat-card">
      <div class="stat-val blue">~200ms</div>
      <div class="stat-label">On-device Inference</div>
    </div>
  </div>

  <div style="margin-top:40px;">
    <h3>Project Goals</h3>
    <div class="steps" style="margin-top:16px;">
      <div class="step">
        <div class="step-num">1</div>
        <div class="step-body"><h4>≥97% classification accuracy on SIPaKMeD test set</h4><p>Achieved 97.34% with ensemble of ResNet50, DenseNet121 &amp; EfficientNet-B3.</p></div>
      </div>
      <div class="step">
        <div class="step-num">2</div>
        <div class="step-body"><h4>3-tier clinical triage mapping</h4><p>Five cell classes mapped to Normal / Benign / Abnormal for actionable results.</p></div>
      </div>
      <div class="step">
        <div class="step-num">3</div>
        <div class="step-body"><h4>Offline-capable Flutter mobile app</h4><p>EfficientNet-B3 TFLite embedded for zero-connectivity inference on Android &amp; iOS.</p></div>
      </div>
      <div class="step">
        <div class="step-num">4</div>
        <div class="step-body"><h4>Cloud REST API on Google Cloud Run</h4><p>FastAPI endpoint auto-scales, billed per-request, integrates with clinic systems.</p></div>
      </div>
      <div class="step">
        <div class="step-num">5</div>
        <div class="step-body"><h4>Gemini-powered educational chatbot</h4><p>System-prompt locked to cervical cancer education; medical-advice guardrails enforced.</p></div>
      </div>
    </div>
  </div>
</section>

<!-- ═══════════════════════ CERVI MODEL ═══════════════════════ -->
<section id="cervi-model">
  <h2>🏗️ Model <span class="accent">Architecture</span></h2>
  <p class="section-intro">A heterogeneous ensemble of three pretrained CNN backbones, each fine-tuned independently on SIPaKMeD, combined via weighted soft voting.</p>

  <!-- Architecture diagram -->
  <div style="background:var(--surface);border:1px solid var(--border);border-radius:var(--radius);padding:28px;margin-bottom:32px;">
    <div style="text-align:center;font-size:12px;color:var(--muted);font-family:var(--mono);margin-bottom:20px;">INPUT → [B, 3, 224, 224] float32</div>
    <div style="display:grid;grid-template-columns:1fr 1fr 1fr;gap:12px;margin-bottom:16px;">
      <div class="arch-box green">
        <strong>ResNet50</strong>
        <small>25.6M params · α₁ = 0.40</small>
        <small style="color:rgba(76,255,176,0.6);margin-top:4px;">Residual blocks · Texture features</small>
      </div>
      <div class="arch-box blue">
        <strong>DenseNet121</strong>
        <small>8.0M params · α₂ = 0.38</small>
        <small style="color:rgba(124,143,255,0.6);margin-top:4px;">Dense connectivity · NC ratio</small>
      </div>
      <div class="arch-box orange">
        <strong>EfficientNet-B3</strong>
        <small>12.2M params · α₃ = 0.22</small>
        <small style="color:rgba(255,140,107,0.6);margin-top:4px;">MBConv + SE · DEPLOYED</small>
      </div>
    </div>
    <div style="text-align:center;color:var(--muted);margin:8px 0;">↓ Softmax (5 classes) per backbone</div>
    <div class="arch-box yellow" style="margin-bottom:12px;">
      <strong>Weighted Soft Voting</strong>
      <small>P_final = 0.40·P_resnet + 0.38·P_dense + 0.22·P_eff</small>
    </div>
    <div style="display:grid;grid-template-columns:repeat(5,1fr);gap:8px;">
      <div style="background:rgba(255,140,107,0.08);border:1px solid rgba(255,140,107,0.2);border-radius:6px;padding:8px;text-align:center;font-size:11px;">
        <div style="color:var(--accent3);font-weight:600;">Dyskeratotic</div>
        <div style="color:var(--muted);">Abnormal</div>
      </div>
      <div style="background:rgba(255,140,107,0.08);border:1px solid rgba(255,140,107,0.2);border-radius:6px;padding:8px;text-align:center;font-size:11px;">
        <div style="color:var(--accent3);font-weight:600;">Koilocytotic</div>
        <div style="color:var(--muted);">Abnormal</div>
      </div>
      <div style="background:rgba(255,209,102,0.08);border:1px solid rgba(255,209,102,0.2);border-radius:6px;padding:8px;text-align:center;font-size:11px;">
        <div style="color:var(--accent4);font-weight:600;">Metaplastic</div>
        <div style="color:var(--muted);">Benign</div>
      </div>
      <div style="background:rgba(76,255,176,0.08);border:1px solid rgba(76,255,176,0.2);border-radius:6px;padding:8px;text-align:center;font-size:11px;">
        <div style="color:var(--accent1);font-weight:600;">Parabasal</div>
        <div style="color:var(--muted);">Normal</div>
      </div>
      <div style="background:rgba(76,255,176,0.08);border:1px solid rgba(76,255,176,0.2);border-radius:6px;padding:8px;text-align:center;font-size:11px;">
        <div style="color:var(--accent1);font-weight:600;">Sup-Interm.</div>
        <div style="color:var(--muted);">Normal</div>
      </div>
    </div>
  </div>

  <h3 style="margin-bottom:16px;">Training Configuration</h3>
  <pre><span class="cm"># Training configuration — all 3 backbones</span>
<span class="var">optimizer</span> = <span class="fn">AdamW</span>(lr=<span class="num">1e-4</span>, weight_decay=<span class="num">1e-5</span>)
<span class="var">scheduler</span> = <span class="fn">CosineAnnealingLR</span>(epochs=<span class="num">30</span>)
<span class="var">batch_size</span> = <span class="num">32</span>
<span class="var">loss</span>       = <span class="fn">CrossEntropyLoss</span>()

<span class="cm"># Preprocessing (Albumentations)</span>
<span class="var">pipeline</span> = [
    <span class="fn">Resize</span>(<span class="num">224</span>, <span class="num">224</span>),
    <span class="fn">CLAHE</span>(),                        <span class="cm"># contrast enhancement</span>
    <span class="fn">HorizontalFlip</span>(p=<span class="num">0.5</span>),
    <span class="fn">Affine</span>(rotate=<span class="num">15</span>, p=<span class="num">0.5</span>),
    <span class="fn">ColorJitter</span>(),
    <span class="fn">Normalize</span>(mean=[<span class="num">0.485</span>, <span class="num">0.456</span>, <span class="num">0.406</span>],
               std=[<span class="num">0.229</span>, <span class="num">0.224</span>, <span class="num">0.225</span>])
]

<span class="cm"># Ensemble soft voting</span>
<span class="var">P_final</span> = <span class="num">0.40</span>*P_resnet + <span class="num">0.38</span>*P_dense + <span class="num">0.22</span>*P_eff</pre>
</section>

<!-- ═══════════════════════ CERVI METRICS ═══════════════════════ -->
<section id="cervi-metrics">
  <h2>📊 Performance <span class="accent">Metrics</span></h2>
  <p class="section-intro">All metrics computed on the held-out test set of 753 images (15% of SIPaKMeD, stratified).</p>

  <h3 style="margin-bottom:16px;">Per-Class F1 Scores</h3>
  <div class="progress-row">
    <div class="progress-label"><span>Parabasal (Normal)</span><span>1.0000</span></div>
    <div class="progress-bar"><div class="progress-fill fill-green" style="width:100%"></div></div>
  </div>
  <div class="progress-row">
    <div class="progress-label"><span>Superficial-Intermediate (Normal)</span><span>0.9963</span></div>
    <div class="progress-bar"><div class="progress-fill fill-green" style="width:99.63%"></div></div>
  </div>
  <div class="progress-row">
    <div class="progress-label"><span>Dyskeratotic (Abnormal)</span><span>0.9720</span></div>
    <div class="progress-bar"><div class="progress-fill fill-blue" style="width:97.2%"></div></div>
  </div>
  <div class="progress-row">
    <div class="progress-label"><span>Metaplastic (Benign)</span><span>0.9605</span></div>
    <div class="progress-bar"><div class="progress-fill fill-blue" style="width:96.05%"></div></div>
  </div>
  <div class="progress-row">
    <div class="progress-label"><span>Koilocytotic (Abnormal)</span><span>0.9467</span></div>
    <div class="progress-bar"><div class="progress-fill fill-orange" style="width:94.67%"></div></div>
  </div>

  <div style="margin-top:36px;">
    <h3 style="margin-bottom:16px;">Model Comparison</h3>
    <table class="data-table">
      <thead>
        <tr><th>Model</th><th>Params (M)</th><th>Test Acc</th><th>F1 Macro</th><th>AUC</th><th>Status</th></tr>
      </thead>
      <tbody>
        <tr><td><strong>Soft Voting Ensemble</strong></td><td>45.8</td><td style="color:var(--accent1)">97.34%</td><td style="color:var(--accent1)">0.9751</td><td style="color:var(--accent1)">0.9984</td><td><span class="pill pill-green">Research</span></td></tr>
        <tr><td>ResNet50</td><td>25.6</td><td>96.41%</td><td>0.9624</td><td>0.9952</td><td><span class="pill pill-blue">Ensemble member</span></td></tr>
        <tr><td>DenseNet121</td><td>8.0</td><td>95.88%</td><td>0.9568</td><td>0.9941</td><td><span class="pill pill-blue">Ensemble member</span></td></tr>
        <tr><td><strong>EfficientNet-B3</strong></td><td>12.2</td><td>95.35%</td><td>0.9520</td><td>0.9928</td><td><span class="pill pill-orange">Deployed ✓</span></td></tr>
        <tr><td>Inception v3</td><td>23.9</td><td>92.81%</td><td>0.9456</td><td>—</td><td><span class="pill" style="background:rgba(255,255,255,0.05);color:var(--muted)">Baseline</span></td></tr>
        <tr><td>MobileNet v2</td><td>3.5</td><td>92.34%</td><td>0.9319</td><td>—</td><td><span class="pill" style="background:rgba(255,255,255,0.05);color:var(--muted)">Baseline</span></td></tr>
      </tbody>
    </table>
  </div>
</section>

<!-- ═══════════════════════ CERVI MOBILE SCREENSHOTS ═══════════════════════ -->
<section id="cervi-mobile">
  <h2>📱 Mobile App <span class="accent">Screenshots</span></h2>
  <p class="section-intro">Flutter app (frontend_cerviai) with 13 feature modules. Works fully offline using on-device EfficientNet-B3 TFLite (42.7 MB).</p>

  <div class="phone-wrap">
    <!-- Phone 1: Home -->
    <div>
      <div class="phone">
        <div class="phone-notch"></div>
        <div class="phone-screen">
          <div class="phone-header">
            <span style="color:var(--accent1);">CerviAI</span>
            <span style="font-size:10px;color:var(--muted);">9:41 AM</span>
          </div>
          <div class="phone-content">
            <div style="background:rgba(76,255,176,0.08);border:1px solid rgba(76,255,176,0.2);border-radius:10px;padding:12px;margin-bottom:12px;">
              <div style="font-size:10px;color:var(--accent1);font-weight:600;margin-bottom:4px;">QUICK ANALYSIS</div>
              <div style="font-size:11px;color:var(--muted);">Tap to upload or capture a Pap smear image</div>
              <div style="background:var(--accent1);color:#000;font-size:10px;font-weight:700;padding:5px 12px;border-radius:6px;display:inline-block;margin-top:8px;">📷  SCAN NOW</div>
            </div>
            <div style="font-size:10px;color:var(--muted);margin-bottom:8px;font-family:var(--mono);">RECENT SCANS</div>
            <div style="font-size:11px;background:var(--surface2);border-radius:8px;padding:8px;margin-bottom:6px;display:flex;justify-content:space-between;">
              <span>Scan_20250512.jpg</span>
              <span style="color:var(--accent1);">Normal</span>
            </div>
            <div style="font-size:11px;background:var(--surface2);border-radius:8px;padding:8px;margin-bottom:6px;display:flex;justify-content:space-between;">
              <span>Scan_20250508.jpg</span>
              <span style="color:var(--accent3);">Abnormal</span>
            </div>
            <div style="font-size:11px;background:var(--surface2);border-radius:8px;padding:8px;display:flex;justify-content:space-between;">
              <span>Scan_20250501.jpg</span>
              <span style="color:var(--accent4);">Benign</span>
            </div>
          </div>
        </div>
      </div>
      <div style="text-align:center;font-size:11px;color:var(--muted);margin-top:10px;font-family:var(--mono);">Home Screen</div>
    </div>

    <!-- Phone 2: Results -->
    <div>
      <div class="phone">
        <div class="phone-notch"></div>
        <div class="phone-screen">
          <div class="phone-header">
            <span>Analysis Result</span>
            <span style="font-size:10px;color:var(--accent1);">✓ Done</span>
          </div>
          <div class="phone-content">
            <div style="text-align:center;margin-bottom:14px;">
              <div style="width:56px;height:56px;border-radius:50%;background:rgba(255,140,107,0.15);border:2px solid var(--accent3);display:flex;align-items:center;justify-content:center;margin:0 auto 8px;font-size:22px;">⚠️</div>
              <div style="font-size:14px;font-weight:700;color:var(--accent3);">ABNORMAL</div>
              <div style="font-size:10px;color:var(--muted);">Koilocytotic cells detected</div>
            </div>
            <div style="background:var(--surface2);border-radius:8px;padding:10px;margin-bottom:10px;">
              <div style="font-size:10px;color:var(--muted);margin-bottom:6px;font-family:var(--mono);">CONFIDENCE</div>
              <div style="height:4px;background:rgba(255,255,255,0.1);border-radius:2px;overflow:hidden;">
                <div style="height:100%;width:91%;background:var(--accent3);border-radius:2px;"></div>
              </div>
              <div style="font-size:12px;color:var(--accent3);margin-top:4px;text-align:right;font-family:var(--mono);">91.3%</div>
            </div>
            <div style="background:rgba(255,140,107,0.08);border:1px solid rgba(255,140,107,0.2);border-radius:8px;padding:8px;font-size:10px;color:var(--accent3);">
              ⚕️ Recommend referral to gynaecologist for further evaluation.
            </div>
            <div style="margin-top:10px;font-size:10px;text-align:center;color:var(--muted);">Model: EfficientNet-B3 TFLite · 187ms</div>
          </div>
        </div>
      </div>
      <div style="text-align:center;font-size:11px;color:var(--muted);margin-top:10px;font-family:var(--mono);">Analysis Result</div>
    </div>

    <!-- Phone 3: Chatbot -->
    <div>
      <div class="phone">
        <div class="phone-notch"></div>
        <div class="phone-screen">
          <div class="phone-header">
            <span style="color:var(--accent2);">AI Assistant</span>
            <span style="font-size:9px;color:var(--muted);">Powered by Gemini</span>
          </div>
          <div class="phone-content">
            <div style="background:var(--surface2);border-radius:8px 8px 8px 0;padding:8px 10px;font-size:10px;margin-bottom:8px;max-width:85%;">
              What does Koilocytotic mean?
            </div>
            <div style="background:rgba(124,143,255,0.12);border:1px solid rgba(124,143,255,0.2);border-radius:8px 8px 0 8px;padding:8px 10px;font-size:10px;margin-bottom:8px;margin-left:auto;max-width:90%;color:var(--text);">
              Koilocytotic cells show characteristic changes caused by HPV infection — enlarged, irregular nuclei with a clear halo around them called "koilocytosis"...
            </div>
            <div style="background:var(--surface2);border-radius:8px 8px 8px 0;padding:8px 10px;font-size:10px;margin-bottom:8px;max-width:85%;">
              Should I be worried?
            </div>
            <div style="background:rgba(124,143,255,0.12);border:1px solid rgba(124,143,255,0.2);border-radius:8px 8px 0 8px;padding:8px 10px;font-size:10px;margin-left:auto;max-width:90%;color:var(--text);">
              This is an educational tool only. Please consult a qualified gynaecologist for diagnosis. 🔒
            </div>
            <div style="background:rgba(255,209,102,0.1);border:1px solid rgba(255,209,102,0.2);border-radius:6px;padding:6px;font-size:9px;color:var(--accent4);margin-top:8px;text-align:center;">
              ⚠️ Not a substitute for medical advice
            </div>
          </div>
        </div>
      </div>
      <div style="text-align:center;font-size:11px;color:var(--muted);margin-top:10px;font-family:var(--mono);">Gemini Chatbot</div>
    </div>

    <!-- Phone 4: Upload -->
    <div>
      <div class="phone">
        <div class="phone-notch"></div>
        <div class="phone-screen">
          <div class="phone-header">
            <span>Upload Image</span>
          </div>
          <div class="phone-content">
            <div style="border:1.5px dashed rgba(76,255,176,0.3);border-radius:12px;padding:24px 16px;text-align:center;margin-bottom:14px;">
              <div style="font-size:28px;margin-bottom:8px;">🔬</div>
              <div style="font-size:11px;color:var(--accent1);font-weight:600;">Drop Pap smear image</div>
              <div style="font-size:10px;color:var(--muted);margin-top:4px;">JPG, PNG up to 10MB</div>
            </div>
            <div style="display:flex;gap:8px;">
              <div style="flex:1;background:rgba(76,255,176,0.1);border:1px solid rgba(76,255,176,0.3);border-radius:8px;padding:8px;text-align:center;font-size:10px;color:var(--accent1);">📷 Camera</div>
              <div style="flex:1;background:rgba(124,143,255,0.1);border:1px solid rgba(124,143,255,0.3);border-radius:8px;padding:8px;text-align:center;font-size:10px;color:var(--accent2);">🗂 Gallery</div>
            </div>
            <div style="margin-top:14px;">
              <div style="font-size:10px;color:var(--muted);margin-bottom:6px;font-family:var(--mono);">INFERENCE MODE</div>
              <div style="display:flex;align-items:center;gap:8px;font-size:10px;">
                <div style="width:28px;height:16px;background:var(--accent1);border-radius:8px;position:relative;">
                  <div style="width:12px;height:12px;background:#000;border-radius:50%;position:absolute;right:2px;top:2px;"></div>
                </div>
                <span>On-device (offline)</span>
              </div>
              <div style="display:flex;align-items:center;gap:8px;font-size:10px;margin-top:6px;">
                <div style="width:28px;height:16px;background:rgba(255,255,255,0.15);border-radius:8px;position:relative;">
                  <div style="width:12px;height:12px;background:rgba(255,255,255,0.5);border-radius:50%;position:absolute;left:2px;top:2px;"></div>
                </div>
                <span style="color:var(--muted);">Cloud REST (latest model)</span>
              </div>
            </div>
          </div>
        </div>
      </div>
      <div style="text-align:center;font-size:11px;color:var(--muted);margin-top:10px;font-family:var(--mono);">Upload Screen</div>
    </div>
  </div>
</section>

<!-- ═══════════════════════ CERVI CLOUD ═══════════════════════ -->
<section id="cervi-cloud">
  <h2>☁️ Cloud <span class="accent">Deployment</span></h2>
  <p class="section-intro">Deployed on Google Cloud Platform (project: <span class="ic">cervicai</span>, region: <span class="ic">asia-south1</span> Mumbai). Zero-cost when idle; scales on demand.</p>

  <!-- Web Dashboard Mock -->
  <div class="mock-container" style="margin-bottom:32px;">
    <div class="mock-bar">
      <div class="mock-dot d-red"></div>
      <div class="mock-dot d-yellow"></div>
      <div class="mock-dot d-green"></div>
      <div class="mock-url">console.cloud.google.com/run/detail/asia-south1/cervical-api</div>
    </div>
    <div class="mock-body">
      <div style="display:grid;grid-template-columns:repeat(auto-fit,minmax(140px,1fr));gap:12px;margin-bottom:20px;">
        <div style="background:var(--surface2);border-radius:8px;padding:12px;">
          <div style="font-size:10px;color:var(--muted);font-family:var(--mono);">SERVICE</div>
          <div style="font-size:14px;font-weight:600;margin-top:4px;color:var(--accent1);">cervical-api</div>
          <div style="font-size:10px;color:var(--muted);">● Running</div>
        </div>
        <div style="background:var(--surface2);border-radius:8px;padding:12px;">
          <div style="font-size:10px;color:var(--muted);font-family:var(--mono);">REGION</div>
          <div style="font-size:13px;font-weight:600;margin-top:4px;">asia-south1</div>
          <div style="font-size:10px;color:var(--muted);">Mumbai</div>
        </div>
        <div style="background:var(--surface2);border-radius:8px;padding:12px;">
          <div style="font-size:10px;color:var(--muted);font-family:var(--mono);">LATENCY (WARM)</div>
          <div style="font-size:14px;font-weight:600;margin-top:4px;color:var(--accent2);">~600ms</div>
          <div style="font-size:10px;color:var(--muted);">Cold: ~10s</div>
        </div>
        <div style="background:var(--surface2);border-radius:8px;padding:12px;">
          <div style="font-size:10px;color:var(--muted);font-family:var(--mono);">RESOURCES</div>
          <div style="font-size:13px;font-weight:600;margin-top:4px;">2 GB RAM</div>
          <div style="font-size:10px;color:var(--muted);">2 vCPU · Scale to zero</div>
        </div>
      </div>
      <div style="font-size:11px;color:var(--muted);font-family:var(--mono);margin-bottom:8px;">STACK</div>
      <div style="display:flex;flex-wrap:wrap;gap:6px;">
        <span class="pill pill-blue">Python 3.11</span>
        <span class="pill pill-blue">FastAPI</span>
        <span class="pill pill-blue">uvicorn</span>
        <span class="pill pill-green">tensorflow-cpu 2.15</span>
        <span class="pill pill-orange">Docker</span>
        <span class="pill pill-yellow">Artifact Registry</span>
        <span class="pill pill-green">Firebase Auth</span>
        <span class="pill pill-blue">Cloud Logging</span>
        <span class="pill pill-orange">Gemini 2.5 Flash-Lite</span>
      </div>
    </div>
  </div>

  <h3 style="margin-bottom:12px;">API Endpoint</h3>
  <pre><span class="cm"># POST /predict — multipart/form-data</span>
<span class="kw">curl</span> -X POST https://cervical-api-XXXX-el.a.run.app/predict \
     -F <span class="str">"image=@pap_smear.jpg"</span> \
     -H <span class="str">"Authorization: Bearer $TOKEN"</span>

<span class="cm"># Response</span>
{
  <span class="str">"predicted_class"</span>: <span class="str">"Koilocytotic"</span>,
  <span class="str">"confidence"</span>: <span class="num">0.913</span>,
  <span class="str">"all_probabilities"</span>: {<span class="str">"Dyskeratotic"</span>: <span class="num">0.071</span>, <span class="str">"Koilocytotic"</span>: <span class="num">0.913</span>, ...},
  <span class="str">"inference_time_ms"</span>: <span class="num">187</span>,
  <span class="str">"disclaimer"</span>: <span class="str">"Not a substitute for professional medical advice."</span>
}</pre>
</section>

<!-- ═══════════════════════ CERVI INSTALL ═══════════════════════ -->
<section id="cervi-install">
  <h2>⚙️ Installation — <span class="accent">CerviAI</span></h2>
  <div class="card-grid card-grid-2">
    <div class="card">
      <h3>Mobile App (Flutter)</h3>
      <pre style="margin-top:12px;font-size:12px;"><span class="cm"># Prerequisites: Flutter ≥3.19, Dart ≥3.3</span>
git clone https://github.com/you/cerviai-flutter
cd cerviai_mobile

<span class="cm"># Add your keys to api_keys.dart</span>
<span class="cm"># (file is gitignored)</span>

flutter pub get
flutter run --release</pre>
      <div style="margin-top:12px;font-size:12px;color:var(--muted);">The EfficientNet-B3 TFLite model is bundled in <span class="ic">assets/efficientnet_b3.tflite</span>.</div>
    </div>
    <div class="card">
      <h3>Cloud API (Docker / Cloud Run)</h3>
      <pre style="margin-top:12px;font-size:12px;"><span class="cm"># Local dev</span>
cd cerviai_api
pip install -r requirements.txt
uvicorn main:app --reload

<span class="cm"># Deploy to Cloud Run</span>
gcloud run deploy cervical-api \
  --source . \
  --region asia-south1 \
  --allow-unauthenticated</pre>
    </div>
  </div>
</section>

<!-- ════════════════ DIVIDER ════════════════ -->
<div class="divider-label">
  <hr>
  <span>second project</span>
  <hr>
</div>

<!-- ═══════════════════════ FEDSKIN OVERVIEW ═══════════════════════ -->
<section id="fed-overview">
  <h2>🔬 FedSkin — Federated Skin Lesion <span class="accent2">Classification</span></h2>
  <p class="section-intro">
    A privacy-preserving federated learning framework that trains a DenseNet-121 classifier across 3 simulated hospital clients on the HAM10000 dermoscopy dataset — without raw images ever leaving local environments. Deployed as a Gradio web app on Hugging Face Spaces.
  </p>

  <div class="stat-grid">
    <div class="stat-card">
      <div class="stat-val blue">87.52%</div>
      <div class="stat-label">Federated Accuracy</div>
    </div>
    <div class="stat-card">
      <div class="stat-val green">0.7997</div>
      <div class="stat-label">Federated Macro F1</div>
    </div>
    <div class="stat-card">
      <div class="stat-val orange">85.82%</div>
      <div class="stat-label">Centralised Baseline</div>
    </div>
    <div class="stat-card">
      <div class="stat-val yellow">16</div>
      <div class="stat-label">FL Rounds to Converge</div>
    </div>
    <div class="stat-card">
      <div class="stat-val blue">10,015</div>
      <div class="stat-label">HAM10000 Images</div>
    </div>
    <div class="stat-card">
      <div class="stat-val green">3</div>
      <div class="stat-label">Simulated Clients</div>
    </div>
  </div>

  <div style="margin-top:36px;">
    <h3 style="margin-bottom:8px;">Why Federated Learning?</h3>
    <p style="color:var(--muted);font-size:14px;line-height:1.7;max-width:700px;">
      Medical imaging data is governed by HIPAA and GDPR. Hospitals cannot share raw dermoscopy images across institutional boundaries. FL solves this by sharing only model weight updates — raw patient images never leave each client DataLoader. The result: a global model that surpasses the centralised baseline (+1.7% accuracy) while satisfying data residency constraints.
    </p>
  </div>
</section>

<!-- ═══════════════════════ FEDSKIN ARCH ═══════════════════════ -->
<section id="fed-arch">
  <h2>🏗️ Federated <span class="accent2">Architecture</span></h2>
  <p class="section-intro">FedAvg aggregation over 3 non-IID client partitions (Dirichlet α=0.5). DenseNet-121 backbone with class-weighted cross-entropy loss.</p>

  <div style="background:var(--surface);border:1px solid var(--border);border-radius:var(--radius);padding:28px;margin-bottom:32px;">
    <!-- Row 1: Clients -->
    <div style="display:grid;grid-template-columns:1fr 1fr 1fr;gap:12px;margin-bottom:16px;">
      <div class="arch-box blue">
        <strong>Client 0 (Hospital A)</strong>
        <small>1,377 samples · MEL dominant</small>
        <small style="color:rgba(124,143,255,0.6);">Local epochs E=2</small>
      </div>
      <div class="arch-box blue">
        <strong>Client 1 (Hospital B)</strong>
        <small>1,598 samples · NV dominant</small>
        <small style="color:rgba(124,143,255,0.6);">Adam lr=1e-4</small>
      </div>
      <div class="arch-box blue">
        <strong>Client 2 (Hospital C)</strong>
        <small>4,235 samples · NV dominant</small>
        <small style="color:rgba(124,143,255,0.6);">Non-IID Dir(0.5)</small>
      </div>
    </div>
    <div style="text-align:center;color:var(--muted);margin-bottom:12px;">↓ Weight updates only · No raw images transmitted ↓</div>
    <!-- Row 2: Server -->
    <div class="arch-box green" style="margin-bottom:16px;">
      <strong>Central Aggregation Server — FedAvg</strong>
      <small>W_global = Σ (n_k / n) · W_k · T=50 max rounds · Early stop P=10, δ=1e-3</small>
    </div>
    <div style="text-align:center;color:var(--muted);margin-bottom:12px;">↓ Updated global weights redistributed ↓</div>
    <!-- Row 3: Output -->
    <div style="display:grid;grid-template-columns:1fr 1fr;gap:12px;">
      <div class="arch-box orange">
        <strong>DenseNet-121 Backbone</strong>
        <small>6.96M params · Dense feature reuse</small>
        <small style="color:rgba(255,140,107,0.6);">7-class classifier · Dropout p=0.2</small>
      </div>
      <div class="arch-box yellow">
        <strong>Gradio Web App</strong>
        <small>Hugging Face Spaces · Public access</small>
        <small style="color:rgba(255,209,102,0.6);">Real-time probability distribution</small>
      </div>
    </div>
  </div>

  <h3 style="margin-bottom:16px;">HAM10000 Dataset Classes</h3>
  <table class="data-table">
    <thead>
      <tr><th>Class</th><th>Abbrev</th><th>Type</th><th>Training Samples</th></tr>
    </thead>
    <tbody>
      <tr><td>Melanocytic Nevi</td><td><span class="ic">NV</span></td><td><span class="pill pill-green">Benign</span></td><td>~6,705 (67%)</td></tr>
      <tr><td>Melanoma</td><td><span class="ic">MEL</span></td><td><span class="pill pill-orange">Malignant</span></td><td>~1,113</td></tr>
      <tr><td>Benign Keratosis</td><td><span class="ic">BKL</span></td><td><span class="pill pill-green">Benign</span></td><td>~1,099</td></tr>
      <tr><td>Basal Cell Carcinoma</td><td><span class="ic">BCC</span></td><td><span class="pill pill-orange">Malignant</span></td><td>~514</td></tr>
      <tr><td>Actinic Keratosis</td><td><span class="ic">AKIEC</span></td><td><span class="pill pill-orange">Pre-malignant</span></td><td>~327</td></tr>
      <tr><td>Vascular Lesions</td><td><span class="ic">VASC</span></td><td><span class="pill pill-blue">Benign</span></td><td>~142</td></tr>
      <tr><td>Dermatofibroma</td><td><span class="ic">DF</span></td><td><span class="pill pill-blue">Benign</span></td><td>~115</td></tr>
    </tbody>
  </table>
</section>

<!-- ═══════════════════════ FEDSKIN METRICS ═══════════════════════ -->
<section id="fed-metrics">
  <h2>📊 Federated vs Centralised <span class="accent2">Metrics</span></h2>
  <p class="section-intro">Global test set: 2,003 images. Federated model converged at round 16 with early stopping.</p>

  <table class="compare-table">
    <thead>
      <tr>
        <th>Metric</th>
        <th>Federated DenseNet-121</th>
        <th>Centralised DenseNet-121</th>
        <th>Delta</th>
      </tr>
    </thead>
    <tbody>
      <tr><td><strong>Accuracy</strong></td><td style="color:var(--accent1);font-family:var(--mono);">0.8752</td><td style="font-family:var(--mono);">0.8582</td><td style="color:var(--accent1);">+1.70%</td></tr>
      <tr><td><strong>Macro Precision</strong></td><td style="color:var(--accent1);font-family:var(--mono);">0.8147</td><td style="font-family:var(--mono);">0.7512</td><td style="color:var(--accent1);">+6.35%</td></tr>
      <tr><td>Macro Recall</td><td style="font-family:var(--mono);">0.7940</td><td style="color:var(--accent2);font-family:var(--mono);">0.8272</td><td style="color:var(--accent3);">−3.32%</td></tr>
      <tr><td><strong>Macro F1</strong></td><td style="color:var(--accent1);font-family:var(--mono);">0.7997</td><td style="font-family:var(--mono);">0.7831</td><td style="color:var(--accent1);">+1.66%</td></tr>
      <tr><td><strong>Weighted F1</strong></td><td style="color:var(--accent1);font-family:var(--mono);">0.8706</td><td style="font-family:var(--mono);">0.8614</td><td style="color:var(--accent1);">+0.92%</td></tr>
      <tr><td>Training Duration</td><td style="font-family:var(--mono);">16 rounds</td><td style="font-family:var(--mono);">40 epochs</td><td style="color:var(--muted);">—</td></tr>
    </tbody>
  </table>

  <div style="margin-top:32px;">
    <h3 style="margin-bottom:16px;">Per-class F1 — Federated Model</h3>
    <div class="progress-row">
      <div class="progress-label"><span>Vascular Lesions (VASC)</span><span>0.9286</span></div>
      <div class="progress-bar"><div class="progress-fill fill-green" style="width:92.86%"></div></div>
    </div>
    <div class="progress-row">
      <div class="progress-label"><span>Melanocytic Nevi (NV)</span><span>0.9405</span></div>
      <div class="progress-bar"><div class="progress-fill fill-green" style="width:94.05%"></div></div>
    </div>
    <div class="progress-row">
      <div class="progress-label"><span>Dermatofibroma (DF)</span><span>0.8511</span></div>
      <div class="progress-bar"><div class="progress-fill fill-blue" style="width:85.11%"></div></div>
    </div>
    <div class="progress-row">
      <div class="progress-label"><span>Basal Cell Carcinoma (BCC)</span><span>0.8447</span></div>
      <div class="progress-bar"><div class="progress-fill fill-blue" style="width:84.47%"></div></div>
    </div>
    <div class="progress-row">
      <div class="progress-label"><span>Benign Keratosis (BKL)</span><span>0.7683</span></div>
      <div class="progress-bar"><div class="progress-fill fill-orange" style="width:76.83%"></div></div>
    </div>
    <div class="progress-row">
      <div class="progress-label"><span>Actinic Keratosis (AKIEC)</span><span>0.6393</span></div>
      <div class="progress-bar"><div class="progress-fill fill-orange" style="width:63.93%"></div></div>
    </div>
    <div class="progress-row">
      <div class="progress-label"><span>Melanoma (MEL) ⚠️ lowest</span><span>0.6257</span></div>
      <div class="progress-bar"><div class="progress-fill" style="width:62.57%;background:var(--accent3)"></div></div>
    </div>
  </div>
</section>

<!-- ═══════════════════════ FEDSKIN WEB APP ═══════════════════════ -->
<section id="fed-web">
  <h2>🌐 Web App <span class="accent2">Screenshots</span></h2>
  <p class="section-intro">Gradio application deployed on Hugging Face Spaces. Accepts dermoscopy image uploads and returns real-time per-class probability distributions.</p>

  <!-- Gradio mock -->
  <div class="mock-container" style="margin-bottom:32px;">
    <div class="mock-bar">
      <div class="mock-dot d-red"></div>
      <div class="mock-dot d-yellow"></div>
      <div class="mock-dot d-green"></div>
      <div class="mock-url">huggingface.co/spaces/vmihirr/fedskin-classifier</div>
    </div>
    <div class="mock-body">
      <div style="display:flex;align-items:center;gap:12px;margin-bottom:20px;border-bottom:1px solid var(--border);padding-bottom:16px;">
        <div style="font-size:20px;">🔬</div>
        <div>
          <div style="font-weight:600;font-size:15px;">FedSkin — Skin Lesion Classifier</div>
          <div style="font-size:12px;color:var(--muted);">Privacy-preserving federated DenseNet-121 · HAM10000 · 7 classes</div>
        </div>
        <span class="pill pill-green" style="margin-left:auto;">Live</span>
      </div>
      <div class="dash-layout">
        <div style="flex:1;padding-right:20px;border-right:1px solid var(--border);">
          <div style="font-size:11px;color:var(--muted);font-family:var(--mono);margin-bottom:8px;">INPUT IMAGE</div>
          <div style="border:1.5px dashed rgba(124,143,255,0.3);border-radius:10px;padding:32px;text-align:center;margin-bottom:16px;">
            <div style="font-size:32px;margin-bottom:8px;">🔬</div>
            <div style="font-size:12px;color:var(--muted);">Drop dermoscopy image here</div>
            <div style="font-size:11px;color:var(--accent2);margin-top:4px;">or click to browse</div>
          </div>
          <div style="background:var(--accent2);color:#000;font-size:12px;font-weight:700;padding:8px;border-radius:6px;text-align:center;cursor:default;">CLASSIFY IMAGE →</div>
        </div>
        <div style="flex:1;padding-left:20px;">
          <div style="font-size:11px;color:var(--muted);font-family:var(--mono);margin-bottom:8px;">PREDICTION RESULT</div>
          <div style="background:rgba(124,143,255,0.08);border:1px solid rgba(124,143,255,0.2);border-radius:8px;padding:12px;margin-bottom:12px;">
            <div style="display:flex;justify-content:space-between;align-items:center;">
              <span style="font-weight:600;color:var(--accent2);">Melanocytic Nevi (NV)</span>
              <span style="font-family:var(--mono);color:var(--accent1);">94.3%</span>
            </div>
            <div style="height:4px;background:rgba(255,255,255,0.1);border-radius:2px;margin-top:8px;overflow:hidden;">
              <div style="height:100%;width:94.3%;background:var(--accent2);border-radius:2px;"></div>
            </div>
          </div>
          <div style="font-size:11px;color:var(--muted);font-family:var(--mono);margin-bottom:8px;">ALL CLASS PROBABILITIES</div>
          <div style="font-size:11px;">
            <div style="display:flex;justify-content:space-between;padding:4px 0;border-bottom:1px solid var(--border);"><span>NV</span><span style="font-family:var(--mono);color:var(--accent2);">0.9430</span></div>
            <div style="display:flex;justify-content:space-between;padding:4px 0;border-bottom:1px solid var(--border);"><span>BKL</span><span style="font-family:var(--mono);">0.0312</span></div>
            <div style="display:flex;justify-content:space-between;padding:4px 0;border-bottom:1px solid var(--border);"><span>MEL</span><span style="font-family:var(--mono);">0.0148</span></div>
            <div style="display:flex;justify-content:space-between;padding:4px 0;border-bottom:1px solid var(--border);"><span>BCC</span><span style="font-family:var(--mono);">0.0059</span></div>
            <div style="display:flex;justify-content:space-between;padding:4px 0;border-bottom:1px solid var(--border);"><span>DF</span><span style="font-family:var(--mono);">0.0028</span></div>
            <div style="display:flex;justify-content:space-between;padding:4px 0;border-bottom:1px solid var(--border);"><span>AKIEC</span><span style="font-family:var(--mono);">0.0015</span></div>
            <div style="display:flex;justify-content:space-between;padding:4px 0;"><span>VASC</span><span style="font-family:var(--mono);">0.0008</span></div>
          </div>
        </div>
      </div>
    </div>
  </div>

  <!-- Training dashboard mock -->
  <div class="mock-container">
    <div class="mock-bar">
      <div class="mock-dot d-red"></div>
      <div class="mock-dot d-yellow"></div>
      <div class="mock-dot d-green"></div>
      <div class="mock-url">FedSkin — Training Dashboard · Round 16/50 · Early stopped</div>
    </div>
    <div class="mock-body">
      <div class="dash-layout">
        <div class="dash-sidebar">
          <div class="nav-section-label">Navigation</div>
          <div class="nav-item active">📊 Training Curves</div>
          <div class="nav-item">📋 Per-Round Metrics</div>
          <div class="nav-item">🏥 Client Analysis</div>
          <div class="nav-item">🔷 Confusion Matrix</div>
          <div class="nav-item">📈 ROC Curves</div>
          <div class="nav-section-label">Clients</div>
          <div class="nav-item">🏥 Hospital A</div>
          <div class="nav-item">🏥 Hospital B</div>
          <div class="nav-item">🏥 Hospital C</div>
        </div>
        <div class="dash-main">
          <div style="display:grid;grid-template-columns:1fr 1fr 1fr;gap:10px;margin-bottom:16px;">
            <div style="background:var(--surface2);border-radius:8px;padding:10px;text-align:center;">
              <div style="font-size:10px;color:var(--muted);">CONVERGED ROUND</div>
              <div style="font-size:20px;font-weight:700;color:var(--accent1);font-family:var(--mono);">16</div>
            </div>
            <div style="background:var(--surface2);border-radius:8px;padding:10px;text-align:center;">
              <div style="font-size:10px;color:var(--muted);">GLOBAL ACCURACY</div>
              <div style="font-size:20px;font-weight:700;color:var(--accent2);font-family:var(--mono);">87.52%</div>
            </div>
            <div style="background:var(--surface2);border-radius:8px;padding:10px;text-align:center;">
              <div style="font-size:10px;color:var(--muted);">MACRO F1</div>
              <div style="font-size:20px;font-weight:700;color:var(--accent4);font-family:var(--mono);">0.7997</div>
            </div>
          </div>
          <!-- Fake sparkline chart -->
          <div style="background:var(--surface2);border-radius:8px;padding:12px;">
            <div style="font-size:10px;color:var(--muted);font-family:var(--mono);margin-bottom:8px;">VALIDATION ACCURACY — FL ROUNDS 1–16</div>
            <svg viewBox="0 0 400 80" xmlns="http://www.w3.org/2000/svg" style="width:100%;height:80px;">
              <polyline points="0,70 25,65 50,55 75,60 100,48 125,52 150,42 175,45 200,38 225,40 250,34 275,37 300,31 325,33 350,28 375,30 400,27"
                fill="none" stroke="rgba(124,143,255,0.4)" stroke-width="1.5"/>
              <polyline points="0,70 25,65 50,55 75,60 100,48 125,52 150,42 175,45 200,38 225,40 250,34 275,37 300,31 325,33 350,28 375,30 400,27"
                fill="none" stroke="#7c8fff" stroke-width="2" stroke-dasharray="none"/>
              <circle cx="400" cy="27" r="4" fill="#7c8fff"/>
              <text x="5" y="78" font-size="9" fill="rgba(255,255,255,0.3)">Round 1</text>
              <text x="360" y="78" font-size="9" fill="rgba(255,255,255,0.3)">Round 16</text>
              <text x="340" y="22" font-size="9" fill="#7c8fff">87.52%</text>
            </svg>
          </div>
        </div>
      </div>
    </div>
  </div>
</section>

<!-- ═══════════════════════ FEDSKIN INSTALL ═══════════════════════ -->
<section id="fed-install">
  <h2>⚙️ Installation — <span class="accent2">FedSkin</span></h2>
  <div class="card-grid card-grid-2">
    <div class="card">
      <h3>Local / Research</h3>
      <pre style="margin-top:12px;font-size:12px;"><span class="cm"># Clone & install</span>
git clone https://github.com/you/fedskin-fl
cd fedskin_fl
pip install -r requirements.txt

<span class="cm"># Run federated training</span>
python federated_train.py \
  --clients 3 \
  --rounds 50 \
  --alpha 0.5 \
  --epochs 2

<span class="cm"># Evaluate on test set</span>
python evaluate.py --checkpoint best_global.pth</pre>
    </div>
    <div class="card">
      <h3>Docker + Gradio</h3>
      <pre style="margin-top:12px;font-size:12px;"><span class="cm"># Build container</span>
docker build -t fedskin-gradio .
docker run -p 7860:7860 fedskin-gradio

<span class="cm"># Deploy to Hugging Face Spaces</span>
<span class="cm"># Push Dockerfile + app.py to your Space repo</span>
git lfs install
git clone https://huggingface.co/spaces/you/fedskin
<span class="cm"># Copy files, push</span>
git push</pre>
    </div>
  </div>
</section>

<!-- ═══════════════════════ COMPARISON ═══════════════════════ -->
<section>
  <h2>⚡ Project <span class="accent">Comparison</span></h2>
  <table class="compare-table">
    <thead>
      <tr><th>Feature</th><th>CerviAI</th><th>FedSkin</th></tr>
    </thead>
    <tbody>
      <tr><td>Task</td><td>Cervical cell classification (Pap smear)</td><td>Skin lesion classification (dermoscopy)</td></tr>
      <tr><td>Dataset</td><td>SIPaKMeD · 5,015 images · 5 classes</td><td>HAM10000 · 10,015 images · 7 classes</td></tr>
      <tr><td>Architecture</td><td>Ensemble (ResNet50 + DenseNet121 + EfficientNet-B3)</td><td>Federated DenseNet-121</td></tr>
      <tr><td>Best Accuracy</td><td style="color:var(--accent1);">97.34% (ensemble)</td><td style="color:var(--accent2);">87.52% (federated)</td></tr>
      <tr><td>Privacy Model</td><td>Centralised (single institution)</td><td>Federated (3 hospital clients, no raw data sharing)</td></tr>
      <tr><td>Mobile App</td><td class="check">✓ Flutter (Android + iOS), offline TFLite</td><td class="cross">✗ Not included</td></tr>
      <tr><td>Web App</td><td class="check">✓ Cloud Run REST API + Firebase Auth</td><td class="check">✓ Gradio on Hugging Face Spaces</td></tr>
      <tr><td>Cloud Platform</td><td>Google Cloud Platform (asia-south1)</td><td>Hugging Face Spaces + Docker</td></tr>
      <tr><td>LLM Integration</td><td class="check">✓ Gemini 2.5 Flash-Lite chatbot</td><td class="cross">✗ Not included</td></tr>
      <tr><td>Deployment Size</td><td>42.7 MB (TFLite) · ~1.2 GB (Docker)</td><td>~130 MB (Docker)</td></tr>
      <tr><td>Compliance</td><td>Disclaimer + confidence thresholds</td><td>HIPAA/GDPR by design (FL data locality)</td></tr>
    </tbody>
  </table>
</section>

<!-- ═══════════════════════ FUTURE WORK ═══════════════════════ -->
<section>
  <h2>🚀 Roadmap &amp; Future <span class="accent">Work</span></h2>
  <div class="card-grid card-grid-3">
    <div class="card">
      <div class="card-icon">🎓</div>
      <h3>Knowledge Distillation</h3>
      <p>Train a single student network to mimic the CerviAI ensemble, closing the 2.3 F1-point deployed-vs-research gap.</p>
    </div>
    <div class="card">
      <div class="card-icon">🔍</div>
      <h3>Whole-Slide Pipeline</h3>
      <p>Integrate YOLOv8 cell detector upstream to process raw slide scans, not just pre-cropped single cells.</p>
    </div>
    <div class="card">
      <div class="card-icon">🌐</div>
      <h3>Cross-Dataset Validation</h3>
      <p>Test CerviAI on Herlev, ISBI 2014 and FedSkin on ISIC 2019 to validate generalisation beyond the training distribution.</p>
    </div>
    <div class="card">
      <div class="card-icon">🔄</div>
      <h3>Active Learning Loop</h3>
      <p>Route low-confidence predictions to expert review; periodic retraining incorporates difficult field cases.</p>
    </div>
    <div class="card">
      <div class="card-icon">🛡️</div>
      <h3>FedProx / SCAFFOLD</h3>
      <p>Replace FedAvg with FedProx or SCAFFOLD to reduce client drift and improve MEL recall in the federated setting.</p>
    </div>
    <div class="card">
      <div class="card-icon">🗣️</div>
      <h3>Multi-language UI</h3>
      <p>Extend the Flutter app to local Indian languages (Telugu, Kannada, Tamil, Hindi) to reach more frontline health workers.</p>
    </div>
  </div>
</section>

<!-- ═══════════════════════ CITATIONS ═══════════════════════ -->
<section>
  <h2>📚 Key <span class="accent">References</span></h2>
  <div style="font-size:13px;color:var(--muted);line-height:2.2;font-family:var(--mono);">
    <div>[1] Esteva et al. — Dermatologist-level classification of skin cancer with deep neural networks. <em>Nature</em> 542, 2017.</div>
    <div>[2] McMahan et al. — Communication-efficient learning of deep networks from decentralized data. <em>AISTATS</em>, 2017.</div>
    <div>[3] Tschandl et al. — The HAM10000 dataset. <em>Scientific Data</em> 5, 2018.</div>
    <div>[4] Huang et al. — Densely connected convolutional networks. <em>IEEE CVPR</em>, 2017.</div>
    <div>[5] SIPaKMeD dataset — Publicly available Pap smear cytology benchmark, 5,015 annotated cervical cell images.</div>
    <div>[6] He et al. — Deep residual learning for image recognition. <em>IEEE CVPR</em>, 2016.</div>
    <div>[7] Tan &amp; Le — EfficientNet: Rethinking model scaling for CNNs. <em>ICML</em>, 2019.</div>
  </div>
</section>

<!-- ═══════════════════════ FOOTER ═══════════════════════ -->
<footer>
  <div style="margin-bottom:8px;">
    <span class="badge badge-green" style="margin-right:6px;">CerviAI</span>
    <span class="badge badge-blue">FedSkin</span>
  </div>
  <div>Bhavana Poli &amp; Vignesh Mihir R · Amrita School of Engineering, Bengaluru</div>
  <div style="margin-top:4px;">Course 24CS733 — Mobile Application Development · May 2025</div>
  <div style="margin-top:8px;color:rgba(255,255,255,0.2);">⚠️ For research and educational purposes only. Not intended for clinical use without professional supervision.</div>
</footer>

</div><!-- /container -->
</body>
</html>
