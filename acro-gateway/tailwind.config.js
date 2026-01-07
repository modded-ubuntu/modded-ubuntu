/** @type {import('tailwindcss').Config} */
module.exports = {
  content: [
    './pages/**/*.{js,ts,jsx,tsx,mdx}',
    './components/**/*.{js,ts,jsx,tsx,mdx}',
    './app/**/*.{js,ts,jsx,tsx,mdx}',
  ],
  theme: {
    extend: {
      colors: {
        'md-primary': '#9c4dcc',
        'md-primary-light': '#d17fff',
        'md-primary-dark': '#6a1b9a',
        'md-secondary': '#ffd54f',
        'md-secondary-dark': '#c8a415',
        'md-surface': '#1a1a2e',
        'md-surface-variant': '#252542',
        'md-surface-container': '#16213e',
      },
      fontFamily: {
        sans: ['Inter', 'Segoe UI', 'system-ui', 'sans-serif'],
        mono: ['JetBrains Mono', 'Fira Code', 'monospace'],
      },
      borderRadius: {
        '2xl': '16px',
        '3xl': '24px',
        '4xl': '32px',
      },
    },
  },
  plugins: [],
}
