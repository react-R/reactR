import { resolve, join } from 'path';
import { defineConfig } from 'vite';

export default defineConfig({
  define: { 'process.env.NODE_ENV': '"production"' },
  build: {
    outDir: join(__dirname, "inst/www/react-tools/"),
    lib: {
      // Could also be a dictionary or array of multiple entry points
      entry: resolve(__dirname, '/srcjs/react-tools.js'),
      name: 'reactR',
      // the proper extensions will be added
      fileName: 'react-tools',
    },
    rollupOptions: {
      external: ['react', 'react-dom', 'jquery', 'shiny'],
      output: {
        globals: {
          'react': 'React',
          'react-dom': 'ReactDOM',
          'jquery': '$',
          'shiny': 'Shiny'
        },
      },
    },
  },
});
