import { defineConfig } from "vite";
import uni from "@dcloudio/vite-plugin-uni";

// https://vitejs.dev/config/
export default defineConfig(() => {
  const target = process.env.VITE_API_PROXY_TARGET;
  return {
    plugins: [uni()],
    server: target
      ? {
          proxy: {
            "/api": {
              target,
              changeOrigin: true,
            },
          },
        }
      : undefined,
  };
});
