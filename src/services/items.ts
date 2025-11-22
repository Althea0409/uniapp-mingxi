let items: { id: number; name: string }[] = [{ id: 1, name: '示例条目' }];

export async function listItems() {
  return items.slice();
}

export async function createItem(name: string) {
  const id = Math.max(...items.map(i => i.id)) + 1;
  const it = { id, name };
  items.push(it);
  return { id };
}
