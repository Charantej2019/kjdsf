# RealtyTrac Website

## Usage

See Angular CLI github page for full usage: https://github.com/angular/angular-cli

```bash
# Serve dev on http://localhost:4225/
ng serve

# Static Build
#  The npm command will execute a build for Browser:
#   ng build --configuration=$ENV	This uses the "Build" section in angular.json. Output in dist/browser
npm run build		# Settings: defaults.ts.          Default "Build" options
npm run build:dev	# Settings: defaults.ts.          Dev "Build" options
npm run build:qa	# Settings: environment.qa.ts.    QA "Build" options
npm run build:uat	# Settings: environment.uat.ts.   UAT "Build" options
npm run build:prod	# Settings: environment.prod.ts.  Production "Build" options

# Server-Side Rendering Build
#  The npm command will first execute a build for Browser and then Server:
#  Does not build an output for "dist/browser", requires a command from previous section
#  ng run realtytrac:server:$ENV	Output in "dist/server".  Uses the "Server" section in angular.json.
npm run build:ssr		# Settings: defaults.ts.          Default "Build" and "Server" options
npm run build:ssrdev	# Settings: defaults.ts.          Dev "Build" and "Server" options
npm run build:ssrqa		# Settings: environment.qa.ts.    QA "Build" and "Server" options
npm run build:ssruat	# Settings: environment.uat.ts.   UAT "Build" and "Server" options
npm run build:ssrprd	# Settings: environment.prod.ts.  Production "Build" and "Server" options

# Example to start SSR server for dev
npm run build:dev
npm run build:ssrdev
npm run serve:ssrdev

# Server-Side Rendering Run
npm run serve:ssr		# Runs "node dist/main.js"


# Serve prod build from dist folder at http://127.0.0.1:8080/#/.
# Requires http server which can be installed with `npm install http-server -g`
npm run prod

# Run prettier which will format the code in the entire project
npm run format

# Run prod build and then use webpack bundle analyzer to check bundle sizes and composition
# Documentation located in /documentation/
npm run build:stats

# Automatically generate documentation
npm run docs

# Run e2e protractor tests
ng e2e

# Run e2e protractor tests without rebuilding every time (faster)
ng e2e --s false

# Update NPM dependencies via Angular CLI
ng update

# Deploy dist folder to git pages. Be sure to update deploy script in package.json
npm run deploy

# Finding unused dependencies
npm install -g depcheck
depcheck
```

### VSCode Tools

- Prettier: https://marketplace.visualstudio.com/items?itemName=esbenp.prettier-vscode
- TS Lint: https://marketplace.visualstudio.com/items?itemName=eg2.tslint

### Visual Studio Tools

- Prettier: https://marketplace.visualstudio.com/items?itemName=MadsKristensen.JavaScriptPrettier
- TS Lint (Note that this requires the project to be in a solution to work): https://marketplace.visualstudio.com/items?itemName=MadsKristensen.WebAnalyzer

## Useful Info

Lazy load libraries. Normally libraries that are shared between lazy loaded routes are all bundled into a single master bundle. This approach will bundle them separately.

- Add a module in `app > components > libs > *` that imports the library and then exports it
- Export the module in the barrel file in `app > components > libs > index.ts`
- In angular.json, add the path to the module in `projects > architect > build > options > lazyModules`
- In the module where the library is needed, import the lazy loaded module from the barrel like `import { DatagridModule } from '$features';` and then add to the ngModule imports array

When working with Yarn/NPM Link and your local NPM package src folders (uncompiled .ts), use the following boilerplate in your root tsconfig so that Angular CLI will compile and build on save and not throw an Angular package error

```bash
"include": [
	"src/**/*",
	"node_modules/libName/**/*",
]
```
