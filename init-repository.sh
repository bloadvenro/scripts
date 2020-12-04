#!/bin/env bash

git init

cat <<- EOF > .gitignore
	# See https://help.github.com/articles/ignoring-files/ for more about ignoring files.

	# dependencies
	/node_modules
	/.pnp
	.pnp.js

	# testing
	/coverage

	# production
	/build

	# misc
	.DS_Store
	.env.local
	.env.development.local
	.env.test.local
	.env.production.local

	npm-debug.log*
	yarn-debug.log*
	yarn-error.log*
EOF

cat <<- EOF > .editorconfig
	root = true

	[*]
	end_of_line = lf
	insert_final_newline = true
	indent_style = space
	indent_size = 2
EOF

cat <<- EOF > package.json
	{
		"private": true,
		"scripts": {
			"postinstall": "husky install"
		}
	}
EOF

yarn add -E prettier

cat <<- EOF > prettier.config.js
	module.exports = {
		"arrowParens": "always",
		"bracketSpacing": true,
		"embeddedLanguageFormatting": "auto",
		"htmlWhitespaceSensitivity": "css",
		"insertPragma": false,
		"jsxBracketSameLine": false,
		"jsxSingleQuote": false,
		"printWidth": 80,
		"proseWrap": "preserve",
		"quoteProps": "as-needed",
		"requirePragma": false,
		"semi": true,
		"singleQuote": false,
		"tabWidth": 2,
		"trailingComma": "es5",
		"useTabs": false,
		"vueIndentScriptAndStyle": false
	}
EOF

touch .prettierignore

yarn add -D @commitlint/config-conventional @commitlint/cli

cat <<- EOF > commitlint.config.js
	module.exports = {extends: ['@commitlint/config-conventional']}
EOF

yarn add -D eslint eslint-config-prettier

cat <<- EOF > .eslintrc.js
	module.exports = {
		"env": {
			"browser": true,
		},
		"parserOptions": {
			"sourceType": "module",
			"ecmaVersion": 2019,
			"ecmaFeatuers": {},
		},
		"plugins": [],
		"extends": [
			"eslint:recommended",
			"eslint-config-prettier"
		],
		"rules": {},
		"overrides": [
			{
				files: [
					".eslintrc.js",
					"*.config.js"
				],
				env: {
					node: true,
				},
			},
		],
		"settings": {},
}
EOF

yarn add -D lint-staged

cat <<- EOF > lint-staged.config.js
	module.exports = {
		"*.+(js|tsx?)": ["eslint --fix", "prettier --write"]
	}
EOF

yarn add -E -D husky@next

yarn husky add commit-msg "yarn commitlint -e $1"
yarn husky add pre-commit "yarn lint-staged"

git add .

git commit -m "chore: initialized repository"
