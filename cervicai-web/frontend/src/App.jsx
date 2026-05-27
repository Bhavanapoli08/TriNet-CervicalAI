import { useMemo, useRef, useState } from 'react';
import axios from 'axios';
import jsPDF from 'jspdf';
import {
  Chart as ChartJS,
  ArcElement,
  CategoryScale,
  LinearScale,
  BarElement,
  Tooltip,
  Legend,
} from 'chart.js';
import { Doughnut, Bar } from 'react-chartjs-2';

ChartJS.register(ArcElement, CategoryScale, LinearScale, BarElement, Tooltip, Legend);

const CLASS_NAMES = [
  'Dyskeratotic',
  'Koilocytotic',
  'Metaplastic',
  'Parabasal',
  'Superficial-Intermediate',
];

const BASE_WEIGHTS = {
  resnet50: 40,
  densenet121: 38,
  efficientnet_b3: 22,
};

const CATEGORY_BADGES = {
  Abnormal: 'bg-rose-500 text-white',
  Benign: 'bg-amber-400 text-slate-950',
  Normal: 'bg-emerald-500 text-white',
};

const CATEGORY_MAP = {
  Dyskeratotic: ['Abnormal', 'high'],
  Koilocytotic: ['Abnormal', 'high'],
  Metaplastic: ['Benign', 'medium'],
  Parabasal: ['Normal', 'low'],
  'Superficial-Intermediate': ['Normal', 'low'],
};

const RISK_LABEL = {
  high: 'High risk',
  medium: 'Medium risk',
  low: 'Low risk',
};

function clamp(value, min, max) {
  return Math.min(Math.max(value, min), max);
}

function App() {
  const [theme, setTheme] = useState('dark');
  const [selectedFile, setSelectedFile] = useState(null);
  const [previewUrl, setPreviewUrl] = useState('');
  const [prediction, setPrediction] = useState(null);
  const [history, setHistory] = useState([]);
  const [weights, setWeights] = useState(BASE_WEIGHTS);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState('');
  const fileInputRef = useRef(null);

  const themeClasses = theme === 'dark' ? 'bg-slate-950 text-slate-100' : 'bg-slate-50 text-slate-950';

  const effectivePrediction = useMemo(() => {
    if (!prediction) return null;
    const totalWeight = weights.resnet50 + weights.densenet121 + weights.efficientnet_b3;
    const normalized = {
      resnet50: weights.resnet50 / totalWeight,
      densenet121: weights.densenet121 / totalWeight,
      efficientnet_b3: weights.efficientnet_b3 / totalWeight,
    };

    const fused = CLASS_NAMES.reduce((acc, cls) => {
      acc[cls] =
        (prediction.per_model_probabilities.resnet50[cls] || 0) * normalized.resnet50 +
        (prediction.per_model_probabilities.densenet121[cls] || 0) * normalized.densenet121 +
        (prediction.per_model_probabilities.efficientnet_b3[cls] || 0) * normalized.efficientnet_b3;
      return acc;
    }, {});

    const bestClass = CLASS_NAMES.reduce((best, cls) => (fused[cls] > fused[best] ? cls : best), CLASS_NAMES[0]);
    const confidence = fused[bestClass] || 0;
    const [category, riskLevel] = CATEGORY_MAP[bestClass] || ['Unknown', 'low'];

    return {
      ...prediction,
      fused,
      predicted_class: bestClass,
      confidence,
      category,
      risk_level: riskLevel,
    };
  }, [prediction, weights]);

  const historyEntries = history.slice().reverse();

  const uploadFile = (file) => {
    if (!file) return;
    if (!file.type.startsWith('image/')) {
      setError('Please upload a valid image file.');
      return;
    }
    if (file.size > 10 * 1024 * 1024) {
      setError('Image must be under 10MB.');
      return;
    }
    const url = URL.createObjectURL(file);
    setSelectedFile(file);
    setPreviewUrl(url);
    setError('');
  };

  const handleDrop = (event) => {
    event.preventDefault();
    const file = event.dataTransfer.files[0];
    uploadFile(file);
  };

  const handleAnalyze = async () => {
    if (!selectedFile) {
      setError('Select an image first.');
      return;
    }
    setLoading(true);
    setError('');
    try {
      const formData = new FormData();
      formData.append('file', selectedFile);
      const response = await axios.post('/predict', formData, {
        headers: { 'Content-Type': 'multipart/form-data' },
      });
      const result = response.data;
      setPrediction(result);
      setWeights(BASE_WEIGHTS);
      setHistory((prev) => [
        {
          id: Date.now(),
          timestamp: new Date().toLocaleString(),
          predicted_class: result.predicted_class,
          confidence: result.confidence,
          ensemble_score: result.ensemble_score,
        },
        ...prev,
      ]);
    } catch (err) {
      const message = err?.response?.data?.detail || err.message || 'Prediction failed';
      setError(message);
    } finally {
      setLoading(false);
    }
  };

  const downloadReport = () => {
    if (!effectivePrediction) return;
    const doc = new jsPDF({ unit: 'pt', format: 'a4' });
    doc.setFontSize(18);
    doc.text('Cervical Cell Prediction Report', 40, 50);
    doc.setFontSize(12);
    doc.text(`Predicted Class: ${effectivePrediction.predicted_class}`, 40, 90);
    doc.text(`Confidence: ${(effectivePrediction.confidence * 100).toFixed(1)}%`, 40, 110);
    doc.text(`Category: ${effectivePrediction.category}`, 40, 130);
    doc.text(`Risk Level: ${RISK_LABEL[effectivePrediction.risk_level]}`, 40, 150);
    doc.text(`Ensemble Score: ${(effectivePrediction.ensemble_score * 100).toFixed(1)}%`, 40, 170);
    doc.text('Individual Model Outputs:', 40, 200);
    let row = 220;
    for (const [model, value] of Object.entries(effectivePrediction.model_outputs)) {
      doc.text(`- ${model}: ${(value * 100).toFixed(1)}%`, 50, row);
      row += 20;
    }
    doc.text('Final Probabilities:', 40, row + 10);
    CLASS_NAMES.forEach((cls, index) => {
      doc.text(`- ${cls}: ${(effectivePrediction.fused[cls] * 100).toFixed(1)}%`, 50, row + 35 + index * 18);
    });
    doc.save('prediction-report.pdf');
  };

  const doughnutData = useMemo(() => {
    if (!effectivePrediction) return null;
    return {
      labels: CLASS_NAMES,
      datasets: [
        {
          data: CLASS_NAMES.map((cls) => Number((effectivePrediction.fused[cls] * 100).toFixed(1))),
          backgroundColor: ['#38bdf8', '#f97316', '#facc15', '#22c55e', '#818cf8'],
          borderWidth: 0,
        },
      ],
    };
  }, [effectivePrediction]);

  const barChartData = useMemo(() => {
    if (!effectivePrediction) return null;
    return {
      labels: CLASS_NAMES,
      datasets: [
        {
          label: 'Probability (%)',
          data: CLASS_NAMES.map((cls) => Number((effectivePrediction.fused[cls] * 100).toFixed(1))),
          backgroundColor: CLASS_NAMES.map((cls) => {
            if (cls === 'Dyskeratotic' || cls === 'Koilocytotic') return '#f43f5e';
            if (cls === 'Metaplastic') return '#f59e0b';
            return '#22c55e';
          }),
          borderRadius: 8,
        },
      ],
    };
  }, [effectivePrediction]);

  const chartOptions = {
    plugins: { legend: { display: false } },
    responsive: true,
    maintainAspectRatio: false,
    scales: {
      y: { beginAtZero: true, max: 100, ticks: { color: theme === 'dark' ? '#e2e8f0' : '#0f172a' } },
      x: { ticks: { color: theme === 'dark' ? '#e2e8f0' : '#0f172a' } },
    },
  };

  return (
    <div className={`min-h-screen ${themeClasses}`}>
      <div className="max-w-7xl mx-auto px-4 py-8">
        <header className="flex flex-col gap-6 md:flex-row md:items-center md:justify-between mb-10">
          <div>
            <span className="inline-flex items-center gap-3 rounded-full bg-white/5 px-4 py-2 text-sm font-semibold text-sky-200 shadow-soft">
              Ensemble CerviAI
            </span>
            <h1 className="mt-5 text-4xl font-semibold tracking-tight">
              Ensemble-Based Cervical Cell Classification
            </h1>
            <p className="mt-3 max-w-2xl text-slate-300">
              Upload a cervical cell image and get predictions using a weighted soft voting ensemble of ResNet50,
              DenseNet121, and EfficientNet-B3. Explore model contributions, confidence, and download a report.
            </p>
          </div>

          <button
            className="inline-flex items-center rounded-full border border-slate-600 bg-slate-900 px-4 py-2 text-sm text-slate-100 transition hover:bg-slate-800"
            onClick={() => setTheme(theme === 'dark' ? 'light' : 'dark')}
          >
            {theme === 'dark' ? 'Switch to Light' : 'Switch to Dark'}
          </button>
        </header>

        <main className="grid gap-8 xl:grid-cols-[1.3fr_1fr]">
          <section className="space-y-6 rounded-[32px] border border-slate-800/80 bg-slate-900/80 p-6 shadow-soft backdrop-blur-xl">
            <div className="space-y-4">
              <h2 className="text-2xl font-semibold">Upload image</h2>
              <div
                className="drag-area group relative flex min-h-[260px] flex-col items-center justify-center gap-4 rounded-3xl border border-slate-700 px-6 text-center transition"
                onDrop={handleDrop}
                onDragOver={(event) => event.preventDefault()}
                onDragEnter={(event) => event.currentTarget.classList.add('drag-over')}
                onDragLeave={(event) => { event.currentTarget.classList.remove('drag-over'); }}
                onClick={() => fileInputRef.current?.click()}
              >
                <input
                  ref={fileInputRef}
                  type="file"
                  accept="image/*"
                  className="hidden"
                  onChange={(event) => uploadFile(event.target.files?.[0])}
                />
                <div className="space-y-2">
                  <p className="text-lg font-semibold">Drop an image here or click to browse</p>
                  <p className="text-sm text-slate-400">Supported formats: JPG, PNG, BMP. Max 10MB.</p>
                </div>
                {previewUrl && (
                  <img
                    src={previewUrl}
                    alt="Preview"
                    className="pointer-events-none h-56 max-h-72 rounded-3xl object-contain"
                  />
                )}
              </div>
              {error && <div className="rounded-3xl border border-rose-500/50 bg-rose-500/10 p-4 text-sm text-rose-200">{error}</div>}
            </div>

            <div className="grid gap-4 sm:grid-cols-2">
              <button
                onClick={handleAnalyze}
                disabled={loading || !selectedFile}
                className="inline-flex items-center justify-center rounded-3xl bg-sky-500 px-5 py-3 text-base font-semibold text-slate-950 transition hover:bg-sky-400 disabled:cursor-not-allowed disabled:opacity-60"
              >
                {loading ? 'Analyzing...' : 'Analyze Image'}
              </button>
              <button
                onClick={() => {
                  setSelectedFile(null);
                  setPreviewUrl('');
                  setPrediction(null);
                  setError('');
                }}
                className="inline-flex items-center justify-center rounded-3xl border border-slate-700 bg-transparent px-5 py-3 text-base text-slate-200 transition hover:border-slate-500"
              >
                Clear
              </button>
            </div>

            <div className="rounded-3xl border border-slate-700 bg-slate-950/80 p-4 text-sm text-slate-400">
              <p className="font-semibold text-slate-100">Ensemble model</p>
              <p className="mt-2 text-sm leading-6">
                ResNet50, DenseNet121, and EfficientNet-B3 predictions are fused using weighted soft voting
                to deliver a stable cervical cell classification result.
              </p>
            </div>
          </section>

          <section className="space-y-6 rounded-[32px] border border-slate-800/80 bg-slate-900/80 p-6 shadow-soft backdrop-blur-xl">
            <div className="flex items-center justify-between gap-3">
              <div>
                <p className="text-sm uppercase tracking-[0.2em] text-sky-400">Results dashboard</p>
                <h2 className="mt-2 text-2xl font-semibold">Prediction summary</h2>
              </div>
              <button
                onClick={downloadReport}
                disabled={!effectivePrediction}
                className="rounded-full bg-slate-800 px-4 py-2 text-sm text-slate-100 transition hover:bg-slate-700 disabled:opacity-50"
              >
                Download PDF
              </button>
            </div>

            {!effectivePrediction ? (
              <div className="rounded-3xl border border-dashed border-slate-700 p-10 text-center text-slate-400">
                Upload an image and analyze to view results here.
              </div>
            ) : (
              <div className="space-y-6">
                <div className="grid gap-4 sm:grid-cols-[1.2fr_0.8fr]">
                  <div className="space-y-4 rounded-3xl bg-slate-950/90 p-5">
                    <div className="flex items-center justify-between gap-4">
                      <div>
                        <p className="text-sm uppercase tracking-[0.2em] text-slate-400">Final class</p>
                        <h3 className="mt-2 text-3xl font-semibold">{effectivePrediction.predicted_class}</h3>
                      </div>
                      <span className={`rounded-full px-4 py-2 text-sm font-semibold ${CATEGORY_BADGES[effectivePrediction.category] || 'bg-slate-600 text-white'}`}>
                        {effectivePrediction.category} · {RISK_LABEL[effectivePrediction.risk_level]}
                      </span>
                    </div>

                    <div className="grid gap-4 sm:grid-cols-[1fr_1fr]">
                      <div className="rounded-3xl border border-slate-700 bg-slate-950/60 p-4 text-center">
                        <p className="text-sm text-slate-400">Confidence score</p>
                        <p className="mt-3 text-4xl font-semibold text-sky-300">{(effectivePrediction.confidence * 100).toFixed(1)}%</p>
                      </div>
                      <div className="rounded-3xl border border-slate-700 bg-slate-950/60 p-4 text-center">
                        <p className="text-sm text-slate-400">Ensemble score</p>
                        <p className="mt-3 text-4xl font-semibold text-emerald-300">{(effectivePrediction.ensemble_score * 100).toFixed(1)}%</p>
                      </div>
                    </div>
                  </div>

                  <div className="rounded-3xl border border-slate-700 bg-slate-950/90 p-5">
                    <div className="relative mx-auto h-64 w-64">
                      <div className="circle-indicator absolute inset-0 rounded-full" style={{ '--value': `${(effectivePrediction.confidence * 100).toFixed(1)}%` }}></div>
                      <div className="absolute inset-0 grid place-items-center rounded-full bg-slate-950/90 text-center">
                        <p className="text-sm text-slate-400">Confidence</p>
                        <p className="mt-2 text-3xl font-semibold">{(effectivePrediction.confidence * 100).toFixed(1)}%</p>
                      </div>
                    </div>
                  </div>
                </div>

                <div className="rounded-3xl border border-slate-700 bg-slate-950/90 p-5">
                  <p className="text-sm uppercase tracking-[0.2em] text-slate-400">Probability bar chart</p>
                  <div className="mt-6 h-72">
                    <Bar data={barChartData} options={chartOptions} />
                  </div>
                </div>

                <div className="grid gap-4 sm:grid-cols-2">
                  <div className="rounded-3xl border border-slate-700 bg-slate-950/90 p-5">
                    <h3 className="text-lg font-semibold">Model contributions</h3>
                    <div className="mt-4 space-y-3">
                      {Object.entries(effectivePrediction.model_outputs).map(([key, value]) => (
                        <div key={key} className="rounded-3xl border border-slate-800 bg-slate-950/80 p-4">
                          <p className="text-sm text-slate-400">{key}</p>
                          <div className="mt-2 flex items-center justify-between gap-3">
                            <span className="font-semibold">{(value * 100).toFixed(1)}%</span>
                            <span className="rounded-full bg-slate-700 px-3 py-1 text-xs text-slate-300">Raw confidence</span>
                          </div>
                        </div>
                      ))}
                    </div>
                  </div>

                  <div className="rounded-3xl border border-slate-700 bg-slate-950/90 p-5">
                    <h3 className="text-lg font-semibold">Weight adjustments</h3>
                    <div className="mt-4 space-y-4">
                      {Object.entries(weights).map(([key, value]) => (
                        <div key={key} className="space-y-2">
                          <div className="flex items-center justify-between gap-4 text-sm text-slate-300">
                            <span>{key.toUpperCase()}</span>
                            <span>{value}%</span>
                          </div>
                          <input
                            type="range"
                            min="0"
                            max="100"
                            value={value}
                            onChange={(event) => {
                              const next = Number(event.target.value);
                              setWeights((current) => ({ ...current, [key]: next }));
                            }}
                            className="w-full accent-sky-400"
                          />
                        </div>
                      ))}
                      <button
                        onClick={() => setWeights(BASE_WEIGHTS)}
                        className="rounded-full bg-slate-800 px-4 py-2 text-sm text-slate-100 hover:bg-slate-700"
                      >
                        Reset weights
                      </button>
                    </div>
                  </div>
                </div>
              </div>
            )}
          </section>
        </main>

        <section className="mt-10 rounded-[32px] border border-slate-800/80 bg-slate-900/80 p-6 shadow-soft backdrop-blur-xl">
          <div className="flex flex-col gap-4 md:flex-row md:items-center md:justify-between">
            <div>
              <h2 className="text-2xl font-semibold">Prediction history</h2>
              <p className="mt-2 text-sm text-slate-400">Keep track of recent analyses and quickly review past ensemble outputs.</p>
            </div>
            <button
              onClick={() => setHistory([])}
              className="rounded-full bg-slate-800 px-4 py-2 text-sm text-slate-100 hover:bg-slate-700"
            >
              Clear history
            </button>
          </div>
          {historyEntries.length === 0 ? (
            <div className="mt-8 rounded-3xl border border-dashed border-slate-700 p-8 text-center text-slate-500">
              No predictions yet. Analyze an image to build history.
            </div>
          ) : (
            <div className="mt-6 grid gap-4 lg:grid-cols-3">
              {historyEntries.map((entry) => (
                <div key={entry.id} className="rounded-3xl border border-slate-800 bg-slate-950/90 p-5">
                  <p className="text-sm text-slate-400">{entry.timestamp}</p>
                  <h3 className="mt-3 text-xl font-semibold">{entry.predicted_class}</h3>
                  <p className="mt-2 text-sm text-slate-400">Confidence: {(entry.confidence * 100).toFixed(1)}%</p>
                  <p className="text-sm text-slate-400">Ensemble score: {(entry.ensemble_score * 100).toFixed(1)}%</p>
                </div>
              ))}
            </div>
          )}
        </section>
      </div>
    </div>
  );
}

export default App;
