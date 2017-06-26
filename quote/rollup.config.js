import resolve from 'rollup-plugin-node-resolve';
import uglify from 'rollup-plugin-uglify';

export default {
	entry: './lib/es6/src/app.js',
	format: 'iife',
	dest: './public/app.js',
	plugins: [resolve()],//, uglify()],
	moduleName: 'app',
}
