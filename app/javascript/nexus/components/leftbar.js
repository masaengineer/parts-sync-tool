// サイドバーの開閉制御
document.addEventListener('turbo:load', () => {
  const leftbarToggle = document.querySelector(
    '[data-action="leftbar-toggle"]'
  );
  const leftmenuWrapper = document.querySelector('.leftmenu-wrapper');
  const leftbarBackdrop = document.querySelector('.leftbar-backdrop');

  if (leftbarToggle && leftmenuWrapper) {
    // トグルボタンのクリックイベント
    leftbarToggle.addEventListener('click', () => {
      leftmenuWrapper.classList.toggle('translate-x-0');
      leftmenuWrapper.classList.toggle('-translate-x-full');

      // バックドロップの表示/非表示
      if (leftbarBackdrop) {
        leftbarBackdrop.classList.toggle('hidden');
        leftbarBackdrop.classList.toggle('fixed');
        leftbarBackdrop.classList.toggle('inset-0');
        leftbarBackdrop.classList.toggle('bg-base-content/30');
        leftbarBackdrop.classList.toggle('z-10');
      }
    });

    // バックドロップのクリックイベント
    if (leftbarBackdrop) {
      leftbarBackdrop.addEventListener('click', () => {
        leftmenuWrapper.classList.remove('translate-x-0');
        leftmenuWrapper.classList.add('-translate-x-full');
        leftbarBackdrop.classList.add('hidden');
        leftbarBackdrop.classList.remove(
          'fixed',
          'inset-0',
          'bg-base-content/30',
          'z-10'
        );
      });
    }
  }
});
