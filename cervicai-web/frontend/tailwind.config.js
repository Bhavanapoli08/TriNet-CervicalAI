export default {
  content: ['./index.html', './src/**/*.{js,jsx}'],
  theme: {
    extend: {
      boxShadow: {
        soft: '0 20px 60px rgba(15, 23, 42, 0.12)',
      },
      backgroundImage: {
        'glass': 'linear-gradient(180deg, rgba(255,255,255,0.9), rgba(255,255,255,0.7))',
      },
    },
  },
  plugins: [],
};
