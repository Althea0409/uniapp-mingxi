export async function listItems() {
  const res = await fetch('/api/items');
  return res.json();
}

export async function createItem(name: string) {
  const res = await fetch('/api/items', {
    method: 'POST',
    headers: { 'content-type': 'application/json' },
    body: JSON.stringify({ name }),
  });
  return res.json();
}

