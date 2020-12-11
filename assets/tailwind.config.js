const defaultTheme = require('tailwindcss/defaultTheme');

module.exports = {
  purge: ["./js/**/*.js", "../lib/**/*.html.eex"],
  darkMode: "media", // or 'media' or 'class'
  theme: {
    extend: {
      fontFamily: {
        sans: ["Neue Haas Grotesk Text Pro Bold", ...defaultTheme.fontFamily.sans]
      }
    },
  },
  variants: {
    extend: {},
  },
  plugins: [],
}
