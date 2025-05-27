let currentIndex = 0;
const items = document.querySelectorAll('.menu-item');
const menu = document.getElementById('menu');
const submenus = document.querySelectorAll('.submenu');

window.addEventListener('message', function (event) {
  if (event.data.action === 'show') {
    document.body.style.display = 'block';
    menu.style.display = 'block';
  } else if (event.data.action === 'hide') {
    document.body.style.display = 'none';
    menu.style.display = 'none';
    submenus.forEach(el => el.style.display = 'none');
  }
});

function changeSelection(direction) {
  items[currentIndex].classList.remove('selected');
  currentIndex = (currentIndex + direction + items.length) % items.length;
  items[currentIndex].classList.add('selected');
}

window.addEventListener('keydown', (e) => {
  if (e.key === 'ArrowDown') {
    changeSelection(1);
  } else if (e.key === 'ArrowUp') {
    changeSelection(-1);
  } else if (e.key === 'Enter') {
    const selected = items[currentIndex].textContent.trim();
    submenus.forEach(el => el.style.display = 'none');
    const submenu = document.getElementById(`${selected.toLowerCase().replace(/ /g, '-')}-sub`);
    if (submenu) submenu.style.display = 'block';
    if (selected === 'Confirm') {
      fetch(`https://${GetParentResourceName()}/saveCharacter`, { method: 'POST' });
    }
  } else if (e.key === 'Backspace') {
    submenus.forEach(el => el.style.display = 'none');
  }
});
