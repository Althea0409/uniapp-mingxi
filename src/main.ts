import { createSSRApp } from "vue";
import { createPinia } from "pinia";
import App from "./App.vue";
import uniBadge from '@dcloudio/uni-ui/lib/uni-badge/uni-badge.vue'
if (import.meta.env.DEV && import.meta.env.VITE_USE_MOCK === 'true') {
  try { const { setupMock } = await import('./mocks/index'); setupMock(); } catch {}
}

export function createApp() {
  const app = createSSRApp(App);
  const pinia = createPinia();
  
  app.use(pinia);
  app.component('uni-badge', uniBadge);
  
  return {
    app,
  };
}

export default {}
