import { createSSRApp } from "vue";
import { createPinia } from "pinia";
import App from "./App.vue";
import uniBadge from '@dcloudio/uni-ui/lib/uni-badge/uni-badge.vue'

export function createApp() {
  const app = createSSRApp(App);
  const pinia = createPinia();
  
  app.use(pinia);
  
  return {
    app,
  };
}

export default {
  components: {uniBadge}
}
