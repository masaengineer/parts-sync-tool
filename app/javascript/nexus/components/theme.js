// テーマ切り替え機能の実装
document.addEventListener('turbo:load', () => {
  const themeToggler = document.querySelector('[data-action="theme-toggle"]');

  if (themeToggler) {
    themeToggler.addEventListener('click', () => {
      const html = document.documentElement;
      const currentTheme = html.getAttribute('data-theme');
      const newTheme = currentTheme === 'light' ? 'dark' : 'light';

      html.setAttribute('data-theme', newTheme);
      localStorage.setItem('theme', newTheme);
    });
  }
});
