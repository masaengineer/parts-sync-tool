// 検索機能の実装
document.addEventListener('turbo:load', () => {
  const searchModal = document.getElementById('search_modal');
  const searchButtons = document.querySelectorAll(
    '[data-action="search-toggle"]'
  );

  if (searchButtons.length > 0) {
    searchButtons.forEach((button) => {
      button.addEventListener('click', () => {
        if (searchModal) {
          searchModal.showModal();
        }
      });
    });
  }
});
