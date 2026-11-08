# Third party dependency licenses

This inventory covers the active FastAPI and React projects, including direct runtime/development dependencies and the transitive packages recorded in their lockfiles. It records declared licenses, not a source-level audit of every bundled component. Reviewed on 2026-11-08. Refresh it whenever either lockfile changes.

ShakeStir application code and original demo content use the root [MIT license](LICENSE). Dependencies retain their own licenses. The source snapshot excludes installed packages, Python environments, compiled frontend output and the separate prototype. Listing packages here does not relicense them or replace their copyright, LICENSE or NOTICE files.

## Findings that need attention

- The frontend uses supported Vite 7.3 with the standard React plugin. Lightning CSS is an optional Vite peer and is not installed or resolved as a package in the lockfile. No locked Node package declares an MPL, GPL, LGPL or AGPL license in the reviewed metadata. Optional peer declarations are capabilities, not installed packages.
- `caniuse-lite` declares CC-BY-4.0 and is a development dependency. Its attribution requirements remain applicable when redistributing it.
- Installed `uvloop` metadata declares MIT and ships both MIT and Apache-2.0 license texts; consult the packaged files when redistributing it.

## React lockfile inventory

The table lists all 289 distinct package/version pairs in `shakestir-react/package-lock.json`, including optional platform packages that are not installed on every machine. License identifiers come from that lockfile. Runtime/development classification follows the root manifest and lockfile flags.

| Declared license | Package/version pairs |
| --- | ---: |
| Apache-2.0 | 20 |
| BSD-2-Clause | 8 |
| BSD-3-Clause | 3 |
| BlueOak-1.0.0 | 2 |
| CC-BY-4.0 | 1 |
| ISC | 11 |
| MIT | 244 |

| Package | Version | Declared license | Role |
| --- | --- | --- | --- |
| [@adobe/css-tools](https://www.npmjs.com/package/@adobe/css-tools/v/4.5.0) | 4.5.0 | MIT | transitive development |
| [@babel/code-frame](https://www.npmjs.com/package/@babel/code-frame/v/7.29.7) | 7.29.7 | MIT | transitive development |
| [@babel/compat-data](https://www.npmjs.com/package/@babel/compat-data/v/7.29.7) | 7.29.7 | MIT | transitive development |
| [@babel/core](https://www.npmjs.com/package/@babel/core/v/7.29.13) | 7.29.13 | MIT | transitive development |
| [@babel/generator](https://www.npmjs.com/package/@babel/generator/v/7.29.13) | 7.29.13 | MIT | transitive development |
| [@babel/helper-compilation-targets](https://www.npmjs.com/package/@babel/helper-compilation-targets/v/7.29.13) | 7.29.13 | MIT | transitive development |
| [@babel/helper-globals](https://www.npmjs.com/package/@babel/helper-globals/v/7.29.7) | 7.29.7 | MIT | transitive development |
| [@babel/helper-module-imports](https://www.npmjs.com/package/@babel/helper-module-imports/v/7.29.7) | 7.29.7 | MIT | transitive development |
| [@babel/helper-module-transforms](https://www.npmjs.com/package/@babel/helper-module-transforms/v/7.29.13) | 7.29.13 | MIT | transitive development |
| [@babel/helper-plugin-utils](https://www.npmjs.com/package/@babel/helper-plugin-utils/v/7.29.7) | 7.29.7 | MIT | transitive development |
| [@babel/helper-string-parser](https://www.npmjs.com/package/@babel/helper-string-parser/v/7.29.13) | 7.29.13 | MIT | transitive development |
| [@babel/helper-validator-identifier](https://www.npmjs.com/package/@babel/helper-validator-identifier/v/7.29.7) | 7.29.7 | MIT | transitive development |
| [@babel/helper-validator-option](https://www.npmjs.com/package/@babel/helper-validator-option/v/7.29.7) | 7.29.7 | MIT | transitive development |
| [@babel/helpers](https://www.npmjs.com/package/@babel/helpers/v/7.29.13) | 7.29.13 | MIT | transitive development |
| [@babel/parser](https://www.npmjs.com/package/@babel/parser/v/7.29.13) | 7.29.13 | MIT | transitive development |
| [@babel/plugin-transform-react-jsx-self](https://www.npmjs.com/package/@babel/plugin-transform-react-jsx-self/v/7.29.7) | 7.29.7 | MIT | transitive development |
| [@babel/plugin-transform-react-jsx-source](https://www.npmjs.com/package/@babel/plugin-transform-react-jsx-source/v/7.29.7) | 7.29.7 | MIT | transitive development |
| [@babel/runtime](https://www.npmjs.com/package/@babel/runtime/v/7.29.13) | 7.29.13 | MIT | transitive development |
| [@babel/template](https://www.npmjs.com/package/@babel/template/v/7.29.7) | 7.29.7 | MIT | transitive development |
| [@babel/traverse](https://www.npmjs.com/package/@babel/traverse/v/7.29.13) | 7.29.13 | MIT | transitive development |
| [@babel/types](https://www.npmjs.com/package/@babel/types/v/7.29.11) | 7.29.11 | MIT | transitive development |
| [@cacheable/memory](https://www.npmjs.com/package/@cacheable/memory/v/2.2.0) | 2.2.0 | MIT | transitive development |
| [@cacheable/utils](https://www.npmjs.com/package/@cacheable/utils/v/2.5.0) | 2.5.0 | MIT | transitive development |
| [@esbuild/aix-ppc64](https://www.npmjs.com/package/@esbuild/aix-ppc64/v/0.28.2) | 0.28.2 | MIT | transitive development |
| [@esbuild/android-arm](https://www.npmjs.com/package/@esbuild/android-arm/v/0.28.2) | 0.28.2 | MIT | transitive development |
| [@esbuild/android-arm64](https://www.npmjs.com/package/@esbuild/android-arm64/v/0.28.2) | 0.28.2 | MIT | transitive development |
| [@esbuild/android-x64](https://www.npmjs.com/package/@esbuild/android-x64/v/0.28.2) | 0.28.2 | MIT | transitive development |
| [@esbuild/darwin-arm64](https://www.npmjs.com/package/@esbuild/darwin-arm64/v/0.28.2) | 0.28.2 | MIT | transitive development |
| [@esbuild/darwin-x64](https://www.npmjs.com/package/@esbuild/darwin-x64/v/0.28.2) | 0.28.2 | MIT | transitive development |
| [@esbuild/freebsd-arm64](https://www.npmjs.com/package/@esbuild/freebsd-arm64/v/0.28.2) | 0.28.2 | MIT | transitive development |
| [@esbuild/freebsd-x64](https://www.npmjs.com/package/@esbuild/freebsd-x64/v/0.28.2) | 0.28.2 | MIT | transitive development |
| [@esbuild/linux-arm](https://www.npmjs.com/package/@esbuild/linux-arm/v/0.28.2) | 0.28.2 | MIT | transitive development |
| [@esbuild/linux-arm64](https://www.npmjs.com/package/@esbuild/linux-arm64/v/0.28.2) | 0.28.2 | MIT | transitive development |
| [@esbuild/linux-ia32](https://www.npmjs.com/package/@esbuild/linux-ia32/v/0.28.2) | 0.28.2 | MIT | transitive development |
| [@esbuild/linux-loong64](https://www.npmjs.com/package/@esbuild/linux-loong64/v/0.28.2) | 0.28.2 | MIT | transitive development |
| [@esbuild/linux-mips64el](https://www.npmjs.com/package/@esbuild/linux-mips64el/v/0.28.2) | 0.28.2 | MIT | transitive development |
| [@esbuild/linux-ppc64](https://www.npmjs.com/package/@esbuild/linux-ppc64/v/0.28.2) | 0.28.2 | MIT | transitive development |
| [@esbuild/linux-riscv64](https://www.npmjs.com/package/@esbuild/linux-riscv64/v/0.28.2) | 0.28.2 | MIT | transitive development |
| [@esbuild/linux-s390x](https://www.npmjs.com/package/@esbuild/linux-s390x/v/0.28.2) | 0.28.2 | MIT | transitive development |
| [@esbuild/linux-x64](https://www.npmjs.com/package/@esbuild/linux-x64/v/0.28.2) | 0.28.2 | MIT | transitive development |
| [@esbuild/netbsd-arm64](https://www.npmjs.com/package/@esbuild/netbsd-arm64/v/0.28.2) | 0.28.2 | MIT | transitive development |
| [@esbuild/netbsd-x64](https://www.npmjs.com/package/@esbuild/netbsd-x64/v/0.28.2) | 0.28.2 | MIT | transitive development |
| [@esbuild/openbsd-arm64](https://www.npmjs.com/package/@esbuild/openbsd-arm64/v/0.28.2) | 0.28.2 | MIT | transitive development |
| [@esbuild/openbsd-x64](https://www.npmjs.com/package/@esbuild/openbsd-x64/v/0.28.2) | 0.28.2 | MIT | transitive development |
| [@esbuild/openharmony-arm64](https://www.npmjs.com/package/@esbuild/openharmony-arm64/v/0.28.2) | 0.28.2 | MIT | transitive development |
| [@esbuild/sunos-x64](https://www.npmjs.com/package/@esbuild/sunos-x64/v/0.28.2) | 0.28.2 | MIT | transitive development |
| [@esbuild/win32-arm64](https://www.npmjs.com/package/@esbuild/win32-arm64/v/0.28.2) | 0.28.2 | MIT | transitive development |
| [@esbuild/win32-ia32](https://www.npmjs.com/package/@esbuild/win32-ia32/v/0.28.2) | 0.28.2 | MIT | transitive development |
| [@esbuild/win32-x64](https://www.npmjs.com/package/@esbuild/win32-x64/v/0.28.2) | 0.28.2 | MIT | transitive development |
| [@eslint-community/eslint-utils](https://www.npmjs.com/package/@eslint-community/eslint-utils/v/4.10.1) | 4.10.1 | MIT | transitive development |
| [@eslint-community/regexpp](https://www.npmjs.com/package/@eslint-community/regexpp/v/4.12.2) | 4.12.2 | MIT | transitive development |
| [@eslint/config-array](https://www.npmjs.com/package/@eslint/config-array/v/0.23.5) | 0.23.5 | Apache-2.0 | transitive development |
| [@eslint/config-helpers](https://www.npmjs.com/package/@eslint/config-helpers/v/0.7.0) | 0.7.0 | Apache-2.0 | transitive development |
| [@eslint/core](https://www.npmjs.com/package/@eslint/core/v/1.2.1) | 1.2.1 | Apache-2.0 | transitive development |
| [@eslint/js](https://www.npmjs.com/package/@eslint/js/v/10.0.1) | 10.0.1 | MIT | direct development |
| [@eslint/object-schema](https://www.npmjs.com/package/@eslint/object-schema/v/3.0.5) | 3.0.5 | Apache-2.0 | transitive development |
| [@eslint/plugin-kit](https://www.npmjs.com/package/@eslint/plugin-kit/v/0.7.3) | 0.7.3 | Apache-2.0 | transitive development |
| [@exodus/bytes](https://www.npmjs.com/package/@exodus/bytes/v/1.16.0) | 1.16.0 | MIT | transitive development |
| [@humanfs/core](https://www.npmjs.com/package/@humanfs/core/v/0.19.2) | 0.19.2 | Apache-2.0 | transitive development |
| [@humanfs/node](https://www.npmjs.com/package/@humanfs/node/v/0.16.8) | 0.16.8 | Apache-2.0 | transitive development |
| [@humanfs/types](https://www.npmjs.com/package/@humanfs/types/v/0.15.0) | 0.15.0 | Apache-2.0 | transitive development |
| [@humanwhocodes/module-importer](https://www.npmjs.com/package/@humanwhocodes/module-importer/v/1.0.1) | 1.0.1 | Apache-2.0 | transitive development |
| [@humanwhocodes/retry](https://www.npmjs.com/package/@humanwhocodes/retry/v/0.4.3) | 0.4.3 | Apache-2.0 | transitive development |
| [@jridgewell/gen-mapping](https://www.npmjs.com/package/@jridgewell/gen-mapping/v/0.3.13) | 0.3.13 | MIT | transitive development |
| [@jridgewell/remapping](https://www.npmjs.com/package/@jridgewell/remapping/v/2.3.5) | 2.3.5 | MIT | transitive development |
| [@jridgewell/resolve-uri](https://www.npmjs.com/package/@jridgewell/resolve-uri/v/3.1.2) | 3.1.2 | MIT | transitive development |
| [@jridgewell/sourcemap-codec](https://www.npmjs.com/package/@jridgewell/sourcemap-codec/v/1.6.0) | 1.6.0 | MIT | transitive development |
| [@jridgewell/trace-mapping](https://www.npmjs.com/package/@jridgewell/trace-mapping/v/0.3.31) | 0.3.31 | MIT | transitive development |
| [@keyv/bigmap](https://www.npmjs.com/package/@keyv/bigmap/v/1.3.1) | 1.3.1 | MIT | transitive development |
| [@keyv/serialize](https://www.npmjs.com/package/@keyv/serialize/v/1.1.1) | 1.1.1 | MIT | transitive development |
| [@playwright/test](https://www.npmjs.com/package/@playwright/test/v/1.65.0) | 1.65.0 | Apache-2.0 | direct development |
| [@remix-run/route-pattern](https://www.npmjs.com/package/@remix-run/route-pattern/v/0.22.1) | 0.22.1 | MIT | transitive runtime |
| [@rolldown/pluginutils](https://www.npmjs.com/package/@rolldown/pluginutils/v/1.0.0-rc.3) | 1.0.0-rc.3 | MIT | transitive development |
| [@rollup/rollup-android-arm-eabi](https://www.npmjs.com/package/@rollup/rollup-android-arm-eabi/v/4.68.0) | 4.68.0 | MIT | transitive development |
| [@rollup/rollup-android-arm64](https://www.npmjs.com/package/@rollup/rollup-android-arm64/v/4.68.0) | 4.68.0 | MIT | transitive development |
| [@rollup/rollup-android-x64](https://www.npmjs.com/package/@rollup/rollup-android-x64/v/4.68.0) | 4.68.0 | MIT | transitive development |
| [@rollup/rollup-darwin-arm64](https://www.npmjs.com/package/@rollup/rollup-darwin-arm64/v/4.68.0) | 4.68.0 | MIT | transitive development |
| [@rollup/rollup-darwin-x64](https://www.npmjs.com/package/@rollup/rollup-darwin-x64/v/4.68.0) | 4.68.0 | MIT | transitive development |
| [@rollup/rollup-freebsd-arm64](https://www.npmjs.com/package/@rollup/rollup-freebsd-arm64/v/4.68.0) | 4.68.0 | MIT | transitive development |
| [@rollup/rollup-freebsd-x64](https://www.npmjs.com/package/@rollup/rollup-freebsd-x64/v/4.68.0) | 4.68.0 | MIT | transitive development |
| [@rollup/rollup-linux-arm-gnueabihf](https://www.npmjs.com/package/@rollup/rollup-linux-arm-gnueabihf/v/4.68.0) | 4.68.0 | MIT | transitive development |
| [@rollup/rollup-linux-arm-musleabihf](https://www.npmjs.com/package/@rollup/rollup-linux-arm-musleabihf/v/4.68.0) | 4.68.0 | MIT | transitive development |
| [@rollup/rollup-linux-arm64-gnu](https://www.npmjs.com/package/@rollup/rollup-linux-arm64-gnu/v/4.68.0) | 4.68.0 | MIT | transitive development |
| [@rollup/rollup-linux-arm64-musl](https://www.npmjs.com/package/@rollup/rollup-linux-arm64-musl/v/4.68.0) | 4.68.0 | MIT | transitive development |
| [@rollup/rollup-linux-loong64-gnu](https://www.npmjs.com/package/@rollup/rollup-linux-loong64-gnu/v/4.68.0) | 4.68.0 | MIT | transitive development |
| [@rollup/rollup-linux-loong64-musl](https://www.npmjs.com/package/@rollup/rollup-linux-loong64-musl/v/4.68.0) | 4.68.0 | MIT | transitive development |
| [@rollup/rollup-linux-ppc64-gnu](https://www.npmjs.com/package/@rollup/rollup-linux-ppc64-gnu/v/4.68.0) | 4.68.0 | MIT | transitive development |
| [@rollup/rollup-linux-ppc64-musl](https://www.npmjs.com/package/@rollup/rollup-linux-ppc64-musl/v/4.68.0) | 4.68.0 | MIT | transitive development |
| [@rollup/rollup-linux-riscv64-gnu](https://www.npmjs.com/package/@rollup/rollup-linux-riscv64-gnu/v/4.68.0) | 4.68.0 | MIT | transitive development |
| [@rollup/rollup-linux-riscv64-musl](https://www.npmjs.com/package/@rollup/rollup-linux-riscv64-musl/v/4.68.0) | 4.68.0 | MIT | transitive development |
| [@rollup/rollup-linux-s390x-gnu](https://www.npmjs.com/package/@rollup/rollup-linux-s390x-gnu/v/4.68.0) | 4.68.0 | MIT | transitive development |
| [@rollup/rollup-linux-x64-gnu](https://www.npmjs.com/package/@rollup/rollup-linux-x64-gnu/v/4.68.0) | 4.68.0 | MIT | transitive development |
| [@rollup/rollup-linux-x64-musl](https://www.npmjs.com/package/@rollup/rollup-linux-x64-musl/v/4.68.0) | 4.68.0 | MIT | transitive development |
| [@rollup/rollup-openbsd-x64](https://www.npmjs.com/package/@rollup/rollup-openbsd-x64/v/4.68.0) | 4.68.0 | MIT | transitive development |
| [@rollup/rollup-openharmony-arm64](https://www.npmjs.com/package/@rollup/rollup-openharmony-arm64/v/4.68.0) | 4.68.0 | MIT | transitive development |
| [@rollup/rollup-win32-arm64-msvc](https://www.npmjs.com/package/@rollup/rollup-win32-arm64-msvc/v/4.68.0) | 4.68.0 | MIT | transitive development |
| [@rollup/rollup-win32-ia32-msvc](https://www.npmjs.com/package/@rollup/rollup-win32-ia32-msvc/v/4.68.0) | 4.68.0 | MIT | transitive development |
| [@rollup/rollup-win32-x64-gnu](https://www.npmjs.com/package/@rollup/rollup-win32-x64-gnu/v/4.68.0) | 4.68.0 | MIT | transitive development |
| [@rollup/rollup-win32-x64-msvc](https://www.npmjs.com/package/@rollup/rollup-win32-x64-msvc/v/4.68.0) | 4.68.0 | MIT | transitive development |
| [@tanstack/query-core](https://www.npmjs.com/package/@tanstack/query-core/v/5.107.1) | 5.107.1 | MIT | transitive runtime |
| [@tanstack/react-query](https://www.npmjs.com/package/@tanstack/react-query/v/5.107.1) | 5.107.1 | MIT | direct runtime |
| [@testing-library/dom](https://www.npmjs.com/package/@testing-library/dom/v/10.4.2) | 10.4.2 | MIT | transitive development |
| [@testing-library/jest-dom](https://www.npmjs.com/package/@testing-library/jest-dom/v/7.0.1) | 7.0.1 | MIT | direct development |
| [@testing-library/react](https://www.npmjs.com/package/@testing-library/react/v/16.3.3) | 16.3.3 | MIT | direct development |
| [@testing-library/user-event](https://www.npmjs.com/package/@testing-library/user-event/v/14.6.8) | 14.6.8 | MIT | direct development |
| [@types/aria-query](https://www.npmjs.com/package/@types/aria-query/v/5.0.4) | 5.0.4 | MIT | transitive development |
| [@types/babel__core](https://www.npmjs.com/package/@types/babel__core/v/7.20.5) | 7.20.5 | MIT | transitive development |
| [@types/babel__generator](https://www.npmjs.com/package/@types/babel__generator/v/7.27.0) | 7.27.0 | MIT | transitive development |
| [@types/babel__template](https://www.npmjs.com/package/@types/babel__template/v/7.4.4) | 7.4.4 | MIT | transitive development |
| [@types/babel__traverse](https://www.npmjs.com/package/@types/babel__traverse/v/7.28.0) | 7.28.0 | MIT | transitive development |
| [@types/chai](https://www.npmjs.com/package/@types/chai/v/5.2.3) | 5.2.3 | MIT | transitive development |
| [@types/deep-eql](https://www.npmjs.com/package/@types/deep-eql/v/4.0.2) | 4.0.2 | MIT | transitive development |
| [@types/esrecurse](https://www.npmjs.com/package/@types/esrecurse/v/4.3.1) | 4.3.1 | MIT | transitive development |
| [@types/estree](https://www.npmjs.com/package/@types/estree/v/1.0.10) | 1.0.10 | MIT | transitive development |
| [@types/json-schema](https://www.npmjs.com/package/@types/json-schema/v/7.0.15) | 7.0.15 | MIT | transitive development |
| [@types/node](https://www.npmjs.com/package/@types/node/v/24.19.2) | 24.19.2 | MIT | direct development |
| [@types/react](https://www.npmjs.com/package/@types/react/v/19.3.0) | 19.3.0 | MIT | direct development |
| [@types/react-dom](https://www.npmjs.com/package/@types/react-dom/v/19.3.0) | 19.3.0 | MIT | direct development |
| [@typescript-eslint/eslint-plugin](https://www.npmjs.com/package/@typescript-eslint/eslint-plugin/v/8.72.1) | 8.72.1 | MIT | transitive development |
| [@typescript-eslint/parser](https://www.npmjs.com/package/@typescript-eslint/parser/v/8.72.1) | 8.72.1 | MIT | transitive development |
| [@typescript-eslint/project-service](https://www.npmjs.com/package/@typescript-eslint/project-service/v/8.72.1) | 8.72.1 | MIT | transitive development |
| [@typescript-eslint/scope-manager](https://www.npmjs.com/package/@typescript-eslint/scope-manager/v/8.72.1) | 8.72.1 | MIT | transitive development |
| [@typescript-eslint/tsconfig-utils](https://www.npmjs.com/package/@typescript-eslint/tsconfig-utils/v/8.72.1) | 8.72.1 | MIT | transitive development |
| [@typescript-eslint/type-utils](https://www.npmjs.com/package/@typescript-eslint/type-utils/v/8.72.1) | 8.72.1 | MIT | transitive development |
| [@typescript-eslint/types](https://www.npmjs.com/package/@typescript-eslint/types/v/8.72.1) | 8.72.1 | MIT | transitive development |
| [@typescript-eslint/typescript-estree](https://www.npmjs.com/package/@typescript-eslint/typescript-estree/v/8.72.1) | 8.72.1 | MIT | transitive development |
| [@typescript-eslint/utils](https://www.npmjs.com/package/@typescript-eslint/utils/v/8.72.1) | 8.72.1 | MIT | transitive development |
| [@typescript-eslint/visitor-keys](https://www.npmjs.com/package/@typescript-eslint/visitor-keys/v/8.72.1) | 8.72.1 | MIT | transitive development |
| [@vitejs/plugin-react](https://www.npmjs.com/package/@vitejs/plugin-react/v/5.2.0) | 5.2.0 | MIT | direct development |
| [@vitest/mocker](https://www.npmjs.com/package/@vitest/mocker/v/5.1.0) | 5.1.0 | MIT | transitive development |
| [@vitest/spy](https://www.npmjs.com/package/@vitest/spy/v/5.1.0) | 5.1.0 | MIT | transitive development |
| [acorn](https://www.npmjs.com/package/acorn/v/8.19.0) | 8.19.0 | MIT | transitive development |
| [acorn-jsx](https://www.npmjs.com/package/acorn-jsx/v/5.3.2) | 5.3.2 | MIT | transitive development |
| [ajv](https://www.npmjs.com/package/ajv/v/6.15.0) | 6.15.0 | MIT | transitive development |
| [ansi-regex](https://www.npmjs.com/package/ansi-regex/v/5.0.1) | 5.0.1 | MIT | transitive development |
| [ansi-styles](https://www.npmjs.com/package/ansi-styles/v/5.2.0) | 5.2.0 | MIT | transitive development |
| [aria-query](https://www.npmjs.com/package/aria-query/v/5.3.0) | 5.3.0 | Apache-2.0 | transitive development |
| [assertion-error](https://www.npmjs.com/package/assertion-error/v/2.0.1) | 2.0.1 | MIT | transitive development |
| [balanced-match](https://www.npmjs.com/package/balanced-match/v/4.0.4) | 4.0.4 | MIT | transitive development |
| [baseline-browser-mapping](https://www.npmjs.com/package/baseline-browser-mapping/v/2.11.35) | 2.11.35 | Apache-2.0 | transitive development |
| [bcp-47](https://www.npmjs.com/package/bcp-47/v/2.1.2) | 2.1.2 | MIT | transitive development |
| [bcp-47-match](https://www.npmjs.com/package/bcp-47-match/v/2.0.3) | 2.0.3 | MIT | transitive development |
| [brace-expansion](https://www.npmjs.com/package/brace-expansion/v/5.0.12) | 5.0.12 | MIT | transitive development |
| [browserslist](https://www.npmjs.com/package/browserslist/v/4.29.5) | 4.29.5 | MIT | transitive development |
| [cacheable](https://www.npmjs.com/package/cacheable/v/2.5.0) | 2.5.0 | MIT | transitive development |
| [caniuse-lite](https://www.npmjs.com/package/caniuse-lite/v/1.0.30001823) | 1.0.30001823 | CC-BY-4.0 | transitive development |
| [chai](https://www.npmjs.com/package/chai/v/6.3.0) | 6.3.0 | MIT | transitive development |
| [convert-source-map](https://www.npmjs.com/package/convert-source-map/v/2.0.0) | 2.0.0 | MIT | transitive development |
| [cookie-es](https://www.npmjs.com/package/cookie-es/v/3.1.1) | 3.1.1 | MIT | transitive runtime |
| [cross-spawn](https://www.npmjs.com/package/cross-spawn/v/7.0.6) | 7.0.6 | MIT | transitive development |
| [css.escape](https://www.npmjs.com/package/css.escape/v/1.5.1) | 1.5.1 | MIT | transitive development |
| [csstype](https://www.npmjs.com/package/csstype/v/3.2.3) | 3.2.3 | MIT | transitive runtime |
| [data-urls](https://www.npmjs.com/package/data-urls/v/8.0.0) | 8.0.0 | MIT | transitive development |
| [debug](https://www.npmjs.com/package/debug/v/4.4.3) | 4.4.3 | MIT | transitive development |
| [decimal.js](https://www.npmjs.com/package/decimal.js/v/10.6.0) | 10.6.0 | MIT | transitive development |
| [deep-is](https://www.npmjs.com/package/deep-is/v/0.1.4) | 0.1.4 | MIT | transitive development |
| [dequal](https://www.npmjs.com/package/dequal/v/2.0.3) | 2.0.3 | MIT | transitive development |
| [dom-accessibility-api](https://www.npmjs.com/package/dom-accessibility-api/v/0.5.16) | 0.5.16 | MIT | transitive development |
| [dom-accessibility-api](https://www.npmjs.com/package/dom-accessibility-api/v/0.6.3) | 0.6.3 | MIT | transitive development |
| [electron-to-chromium](https://www.npmjs.com/package/electron-to-chromium/v/1.5.478) | 1.5.478 | ISC | transitive development |
| [entities](https://www.npmjs.com/package/entities/v/9.0.0) | 9.0.0 | BSD-2-Clause | transitive development |
| [es-module-lexer](https://www.npmjs.com/package/es-module-lexer/v/2.3.2) | 2.3.2 | MIT | transitive development |
| [esbuild](https://www.npmjs.com/package/esbuild/v/0.28.2) | 0.28.2 | MIT | transitive development |
| [escalade](https://www.npmjs.com/package/escalade/v/3.2.0) | 3.2.0 | MIT | transitive development |
| [escape-string-regexp](https://www.npmjs.com/package/escape-string-regexp/v/4.0.0) | 4.0.0 | MIT | transitive development |
| [eslint](https://www.npmjs.com/package/eslint/v/10.14.0) | 10.14.0 | MIT | direct development |
| [eslint-plugin-react-hooks](https://www.npmjs.com/package/eslint-plugin-react-hooks/v/7.1.1) | 7.1.1 | MIT | direct development |
| [eslint-plugin-react-refresh](https://www.npmjs.com/package/eslint-plugin-react-refresh/v/0.5.7) | 0.5.7 | MIT | direct development |
| [eslint-scope](https://www.npmjs.com/package/eslint-scope/v/9.1.2) | 9.1.2 | BSD-2-Clause | transitive development |
| [eslint-visitor-keys](https://www.npmjs.com/package/eslint-visitor-keys/v/3.4.3) | 3.4.3 | Apache-2.0 | transitive development |
| [eslint-visitor-keys](https://www.npmjs.com/package/eslint-visitor-keys/v/5.0.1) | 5.0.1 | Apache-2.0 | transitive development |
| [espree](https://www.npmjs.com/package/espree/v/11.2.0) | 11.2.0 | BSD-2-Clause | transitive development |
| [esquery](https://www.npmjs.com/package/esquery/v/1.7.0) | 1.7.0 | BSD-3-Clause | transitive development |
| [esrecurse](https://www.npmjs.com/package/esrecurse/v/4.3.0) | 4.3.0 | BSD-2-Clause | transitive development |
| [estraverse](https://www.npmjs.com/package/estraverse/v/5.3.0) | 5.3.0 | BSD-2-Clause | transitive development |
| [estree-walker](https://www.npmjs.com/package/estree-walker/v/3.0.3) | 3.0.3 | MIT | transitive development |
| [esutils](https://www.npmjs.com/package/esutils/v/2.0.3) | 2.0.3 | BSD-2-Clause | transitive development |
| [expect-type](https://www.npmjs.com/package/expect-type/v/1.4.0) | 1.4.0 | Apache-2.0 | transitive development |
| [fast-deep-equal](https://www.npmjs.com/package/fast-deep-equal/v/3.1.3) | 3.1.3 | MIT | transitive development |
| [fast-json-stable-stringify](https://www.npmjs.com/package/fast-json-stable-stringify/v/2.1.0) | 2.1.0 | MIT | transitive development |
| [fast-levenshtein](https://www.npmjs.com/package/fast-levenshtein/v/2.0.6) | 2.0.6 | MIT | transitive development |
| [fdir](https://www.npmjs.com/package/fdir/v/6.5.0) | 6.5.0 | MIT | transitive development |
| [file-entry-cache](https://www.npmjs.com/package/file-entry-cache/v/11.1.5) | 11.1.5 | MIT | transitive development |
| [find-up](https://www.npmjs.com/package/find-up/v/5.0.0) | 5.0.0 | MIT | transitive development |
| [flat-cache](https://www.npmjs.com/package/flat-cache/v/6.1.23) | 6.1.23 | MIT | transitive development |
| [flatted](https://www.npmjs.com/package/flatted/v/3.4.4) | 3.4.4 | ISC | transitive development |
| [fsevents](https://www.npmjs.com/package/fsevents/v/2.3.3) | 2.3.3 | MIT | transitive development |
| [gensync](https://www.npmjs.com/package/gensync/v/1.0.0-beta.2) | 1.0.0-beta.2 | MIT | transitive development |
| [glob-parent](https://www.npmjs.com/package/glob-parent/v/6.0.2) | 6.0.2 | ISC | transitive development |
| [globals](https://www.npmjs.com/package/globals/v/17.14.0) | 17.14.0 | MIT | direct development |
| [hashery](https://www.npmjs.com/package/hashery/v/1.5.1) | 1.5.1 | MIT | transitive development |
| [hermes-estree](https://www.npmjs.com/package/hermes-estree/v/0.25.1) | 0.25.1 | MIT | transitive development |
| [hermes-parser](https://www.npmjs.com/package/hermes-parser/v/0.25.1) | 0.25.1 | MIT | transitive development |
| [hookified](https://www.npmjs.com/package/hookified/v/1.15.1) | 1.15.1 | MIT | transitive development |
| [hookified](https://www.npmjs.com/package/hookified/v/2.2.0) | 2.2.0 | MIT | transitive development |
| [html-encoding-sniffer](https://www.npmjs.com/package/html-encoding-sniffer/v/7.0.0) | 7.0.0 | MIT | transitive development |
| [ignore](https://www.npmjs.com/package/ignore/v/5.3.2) | 5.3.2 | MIT | transitive development |
| [ignore](https://www.npmjs.com/package/ignore/v/7.0.14) | 7.0.14 | MIT | transitive development |
| [imurmurhash](https://www.npmjs.com/package/imurmurhash/v/0.1.4) | 0.1.4 | MIT | transitive development |
| [indent-string](https://www.npmjs.com/package/indent-string/v/4.0.0) | 4.0.0 | MIT | transitive development |
| [is-alphabetical](https://www.npmjs.com/package/is-alphabetical/v/2.0.1) | 2.0.1 | MIT | transitive development |
| [is-alphanumerical](https://www.npmjs.com/package/is-alphanumerical/v/2.0.1) | 2.0.1 | MIT | transitive development |
| [is-decimal](https://www.npmjs.com/package/is-decimal/v/2.0.1) | 2.0.1 | MIT | transitive development |
| [is-extglob](https://www.npmjs.com/package/is-extglob/v/2.1.1) | 2.1.1 | MIT | transitive development |
| [is-glob](https://www.npmjs.com/package/is-glob/v/4.0.3) | 4.0.3 | MIT | transitive development |
| [is-potential-custom-element-name](https://www.npmjs.com/package/is-potential-custom-element-name/v/1.0.1) | 1.0.1 | MIT | transitive development |
| [isexe](https://www.npmjs.com/package/isexe/v/2.0.0) | 2.0.0 | ISC | transitive development |
| [js-tokens](https://www.npmjs.com/package/js-tokens/v/4.0.0) | 4.0.0 | MIT | transitive development |
| [jsdom](https://www.npmjs.com/package/jsdom/v/31.0.0) | 31.0.0 | MIT | direct development |
| [jsesc](https://www.npmjs.com/package/jsesc/v/3.1.0) | 3.1.0 | MIT | transitive development |
| [json-schema-traverse](https://www.npmjs.com/package/json-schema-traverse/v/0.4.1) | 0.4.1 | MIT | transitive development |
| [json-stable-stringify-without-jsonify](https://www.npmjs.com/package/json-stable-stringify-without-jsonify/v/1.0.1) | 1.0.1 | MIT | transitive development |
| [json5](https://www.npmjs.com/package/json5/v/2.2.3) | 2.2.3 | MIT | transitive development |
| [keyv](https://www.npmjs.com/package/keyv/v/5.6.0) | 5.6.0 | MIT | transitive development |
| [levn](https://www.npmjs.com/package/levn/v/0.4.1) | 0.4.1 | MIT | transitive development |
| [locate-path](https://www.npmjs.com/package/locate-path/v/6.0.0) | 6.0.0 | MIT | transitive development |
| [lru-cache](https://www.npmjs.com/package/lru-cache/v/11.5.3) | 11.5.3 | BlueOak-1.0.0 | transitive development |
| [lru-cache](https://www.npmjs.com/package/lru-cache/v/5.1.1) | 5.1.1 | ISC | transitive development |
| [lz-string](https://www.npmjs.com/package/lz-string/v/1.5.0) | 1.5.0 | MIT | transitive development |
| [magic-string](https://www.npmjs.com/package/magic-string/v/1.4.5) | 1.4.5 | MIT | transitive development |
| [min-indent](https://www.npmjs.com/package/min-indent/v/1.0.1) | 1.0.1 | MIT | transitive development |
| [minimatch](https://www.npmjs.com/package/minimatch/v/10.2.6) | 10.2.6 | BlueOak-1.0.0 | transitive development |
| [ms](https://www.npmjs.com/package/ms/v/2.1.3) | 2.1.3 | MIT | transitive development |
| [nanoid](https://www.npmjs.com/package/nanoid/v/3.3.20) | 3.3.20 | MIT | transitive development |
| [natural-compare](https://www.npmjs.com/package/natural-compare/v/1.4.0) | 1.4.0 | MIT | transitive development |
| [node-releases](https://www.npmjs.com/package/node-releases/v/2.0.63) | 2.0.63 | MIT | transitive development |
| [obug](https://www.npmjs.com/package/obug/v/3.0.0) | 3.0.0 | MIT | transitive development |
| [optionator](https://www.npmjs.com/package/optionator/v/0.9.4) | 0.9.4 | MIT | transitive development |
| [p-limit](https://www.npmjs.com/package/p-limit/v/3.1.0) | 3.1.0 | MIT | transitive development |
| [p-locate](https://www.npmjs.com/package/p-locate/v/5.0.0) | 5.0.0 | MIT | transitive development |
| [parse5](https://www.npmjs.com/package/parse5/v/8.1.0) | 8.1.0 | MIT | transitive development |
| [parse5-parser-stream](https://www.npmjs.com/package/parse5-parser-stream/v/8.1.0) | 8.1.0 | MIT | transitive development |
| [path-exists](https://www.npmjs.com/package/path-exists/v/4.0.0) | 4.0.0 | MIT | transitive development |
| [path-key](https://www.npmjs.com/package/path-key/v/3.1.1) | 3.1.1 | MIT | transitive development |
| [picocolors](https://www.npmjs.com/package/picocolors/v/1.1.1) | 1.1.1 | ISC | transitive development |
| [picomatch](https://www.npmjs.com/package/picomatch/v/4.0.7) | 4.0.7 | MIT | transitive development |
| [playwright](https://www.npmjs.com/package/playwright/v/1.65.0) | 1.65.0 | Apache-2.0 | transitive development |
| [playwright-core](https://www.npmjs.com/package/playwright-core/v/1.65.0) | 1.65.0 | Apache-2.0 | transitive development |
| [postcss](https://www.npmjs.com/package/postcss/v/8.5.32) | 8.5.32 | MIT | transitive development |
| [prelude-ls](https://www.npmjs.com/package/prelude-ls/v/1.2.1) | 1.2.1 | MIT | transitive development |
| [pretty-format](https://www.npmjs.com/package/pretty-format/v/27.5.1) | 27.5.1 | MIT | transitive development |
| [punycode](https://www.npmjs.com/package/punycode/v/2.3.1) | 2.3.1 | MIT | transitive development |
| [qified](https://www.npmjs.com/package/qified/v/0.10.1) | 0.10.1 | MIT | transitive development |
| [react](https://www.npmjs.com/package/react/v/19.3.1) | 19.3.1 | MIT | direct runtime |
| [react-dom](https://www.npmjs.com/package/react-dom/v/19.3.1) | 19.3.1 | MIT | direct runtime |
| [react-is](https://www.npmjs.com/package/react-is/v/17.0.2) | 17.0.2 | MIT | transitive development |
| [react-refresh](https://www.npmjs.com/package/react-refresh/v/0.18.0) | 0.18.0 | MIT | transitive development |
| [react-router](https://www.npmjs.com/package/react-router/v/8.5.1) | 8.5.1 | MIT | direct runtime |
| [redent](https://www.npmjs.com/package/redent/v/3.0.0) | 3.0.0 | MIT | transitive development |
| [rollup](https://www.npmjs.com/package/rollup/v/4.68.0) | 4.68.0 | MIT | transitive development |
| [saxes](https://www.npmjs.com/package/saxes/v/6.0.0) | 6.0.0 | ISC | transitive development |
| [scheduler](https://www.npmjs.com/package/scheduler/v/0.28.0) | 0.28.0 | MIT | transitive runtime |
| [semver](https://www.npmjs.com/package/semver/v/6.3.2) | 6.3.2 | ISC | transitive development |
| [semver](https://www.npmjs.com/package/semver/v/7.8.6) | 7.8.6 | ISC | transitive development |
| [shebang-command](https://www.npmjs.com/package/shebang-command/v/2.0.0) | 2.0.0 | MIT | transitive development |
| [shebang-regex](https://www.npmjs.com/package/shebang-regex/v/3.0.0) | 3.0.0 | MIT | transitive development |
| [source-map-js](https://www.npmjs.com/package/source-map-js/v/1.2.2) | 1.2.2 | BSD-3-Clause | transitive development |
| [std-env](https://www.npmjs.com/package/std-env/v/4.3.0) | 4.3.0 | MIT | transitive development |
| [strip-indent](https://www.npmjs.com/package/strip-indent/v/3.0.0) | 3.0.0 | MIT | transitive development |
| [tinybench](https://www.npmjs.com/package/tinybench/v/6.2.3) | 6.2.3 | MIT | transitive development |
| [tinyexec](https://www.npmjs.com/package/tinyexec/v/1.3.1) | 1.3.1 | MIT | transitive development |
| [tinyglobby](https://www.npmjs.com/package/tinyglobby/v/0.2.17) | 0.2.17 | MIT | transitive development |
| [tldts](https://www.npmjs.com/package/tldts/v/7.4.19) | 7.4.19 | MIT | transitive development |
| [tldts-core](https://www.npmjs.com/package/tldts-core/v/7.4.20) | 7.4.20 | MIT | transitive development |
| [tough-cookie](https://www.npmjs.com/package/tough-cookie/v/6.1.0) | 6.1.0 | BSD-3-Clause | transitive development |
| [tr46](https://www.npmjs.com/package/tr46/v/7.0.0) | 7.0.0 | MIT | transitive development |
| [ts-api-utils](https://www.npmjs.com/package/ts-api-utils/v/2.5.0) | 2.5.0 | MIT | transitive development |
| [type-check](https://www.npmjs.com/package/type-check/v/0.4.0) | 0.4.0 | MIT | transitive development |
| [typescript](https://www.npmjs.com/package/typescript/v/6.0.3) | 6.0.3 | Apache-2.0 | direct development |
| [typescript-eslint](https://www.npmjs.com/package/typescript-eslint/v/8.72.1) | 8.72.1 | MIT | direct development |
| [undici](https://www.npmjs.com/package/undici/v/8.12.4) | 8.12.4 | MIT | transitive development |
| [undici-types](https://www.npmjs.com/package/undici-types/v/7.24.6) | 7.24.6 | MIT | transitive development |
| [update-browserslist-db](https://www.npmjs.com/package/update-browserslist-db/v/1.3.4) | 1.3.4 | MIT | transitive development |
| [uri-js](https://www.npmjs.com/package/uri-js/v/4.4.1) | 4.4.1 | BSD-2-Clause | transitive development |
| [vite](https://www.npmjs.com/package/vite/v/7.3.7) | 7.3.7 | MIT | direct development |
| [vitest](https://www.npmjs.com/package/vitest/v/5.1.0) | 5.1.0 | MIT | direct development |
| [w3c-xmlserializer](https://www.npmjs.com/package/w3c-xmlserializer/v/6.0.0) | 6.0.0 | MIT | transitive development |
| [webidl-conversions](https://www.npmjs.com/package/webidl-conversions/v/8.0.1) | 8.0.1 | BSD-2-Clause | transitive development |
| [whatwg-mimetype](https://www.npmjs.com/package/whatwg-mimetype/v/5.0.0) | 5.0.0 | MIT | transitive development |
| [whatwg-url](https://www.npmjs.com/package/whatwg-url/v/17.3.0) | 17.3.0 | MIT | transitive development |
| [which](https://www.npmjs.com/package/which/v/2.0.2) | 2.0.2 | ISC | transitive development |
| [why-is-node-running](https://www.npmjs.com/package/why-is-node-running/v/3.2.1) | 3.2.1 | MIT | transitive development |
| [word-wrap](https://www.npmjs.com/package/word-wrap/v/1.2.5) | 1.2.5 | MIT | transitive development |
| [xml-name-validator](https://www.npmjs.com/package/xml-name-validator/v/5.0.0) | 5.0.0 | Apache-2.0 | transitive development |
| [xmlchars](https://www.npmjs.com/package/xmlchars/v/2.2.0) | 2.2.0 | MIT | transitive development |
| [yallist](https://www.npmjs.com/package/yallist/v/3.1.1) | 3.1.1 | ISC | transitive development |
| [yocto-queue](https://www.npmjs.com/package/yocto-queue/v/0.1.0) | 0.1.0 | MIT | transitive development |
| [zod](https://www.npmjs.com/package/zod/v/4.6.7) | 4.6.7 | MIT | transitive development |
| [zod-validation-error](https://www.npmjs.com/package/zod-validation-error/v/4.0.2) | 4.0.2 | MIT | transitive development |

## Python lockfile inventory

The table lists all 36 third-party packages in `shakestir-fastapi/uv.lock`. Most licenses were checked against the installed distributions for the locked versions on Python 3.11/Linux. The platform-specific `colorama` and `httpx2-jsfetch` entries were checked using their PyPI version metadata and, for colorama, its [upstream BSD license](https://github.com/tartley/colorama/blob/master/LICENSE.txt). The inventory includes the development extra.

| Package | Version | Declared license |
| --- | --- | --- |
| [alembic](https://pypi.org/project/alembic/1.20.1/) | 1.20.1 | MIT |
| [annotated-doc](https://pypi.org/project/annotated-doc/0.0.5/) | 0.0.5 | MIT |
| [annotated-types](https://pypi.org/project/annotated-types/0.8.0/) | 0.8.0 | MIT |
| [anyio](https://pypi.org/project/anyio/4.16.0/) | 4.16.0 | MIT |
| [click](https://pypi.org/project/click/8.5.1/) | 8.5.1 | BSD-3-Clause |
| [colorama](https://pypi.org/project/colorama/0.4.6/) | 0.4.6 | BSD-3-Clause |
| [fastapi](https://pypi.org/project/fastapi/0.162.2/) | 0.162.2 | MIT |
| [h11](https://pypi.org/project/h11/0.16.0/) | 0.16.0 | MIT |
| [httpcore2](https://pypi.org/project/httpcore2/2.16.0/) | 2.16.0 | BSD-3-Clause |
| [httptools](https://pypi.org/project/httptools/0.9.0/) | 0.9.0 | MIT |
| [httpx2](https://pypi.org/project/httpx2/2.16.0/) | 2.16.0 | BSD-3-Clause |
| [httpx2-jsfetch](https://pypi.org/project/httpx2-jsfetch/1.0/) | 1.0 | BSD-3-Clause |
| [idna](https://pypi.org/project/idna/3.20/) | 3.20 | BSD-3-Clause |
| [iniconfig](https://pypi.org/project/iniconfig/2.3.1/) | 2.3.1 | MIT |
| [mako](https://pypi.org/project/mako/1.4.3/) | 1.4.3 | MIT |
| [markupsafe](https://pypi.org/project/markupsafe/3.0.4/) | 3.0.4 | BSD-3-Clause |
| [opentelemetry-api](https://pypi.org/project/opentelemetry-api/1.45.2/) | 1.45.2 | Apache-2.0 |
| [packaging](https://pypi.org/project/packaging/26.3/) | 26.3 | Apache-2.0 OR BSD-2-Clause |
| [pluggy](https://pypi.org/project/pluggy/1.7.0/) | 1.7.0 | MIT |
| [pydantic](https://pypi.org/project/pydantic/2.14.3/) | 2.14.3 | MIT |
| [pydantic-core](https://pypi.org/project/pydantic-core/2.50.4/) | 2.50.4 | MIT |
| [pydantic-settings](https://pypi.org/project/pydantic-settings/2.16.2/) | 2.16.2 | MIT |
| [pygments](https://pypi.org/project/pygments/2.21.0/) | 2.21.0 | BSD-2-Clause |
| [pytest](https://pypi.org/project/pytest/9.2.0/) | 9.2.0 | MIT |
| [python-dotenv](https://pypi.org/project/python-dotenv/1.2.4/) | 1.2.4 | BSD-3-Clause |
| [pyyaml](https://pypi.org/project/pyyaml/6.0.3/) | 6.0.3 | MIT |
| [ruff](https://pypi.org/project/ruff/0.17.4/) | 0.17.4 | MIT |
| [sqlalchemy](https://pypi.org/project/sqlalchemy/2.1.8/) | 2.1.8 | MIT |
| [starlette](https://pypi.org/project/starlette/1.10.0/) | 1.10.0 | BSD-3-Clause |
| [truststore](https://pypi.org/project/truststore/0.10.5/) | 0.10.5 | MIT |
| [typing-extensions](https://pypi.org/project/typing-extensions/4.16.0/) | 4.16.0 | PSF-2.0 |
| [typing-inspection](https://pypi.org/project/typing-inspection/0.4.5/) | 0.4.5 | MIT |
| [uvicorn](https://pypi.org/project/uvicorn/0.54.0/) | 0.54.0 | BSD-3-Clause |
| [uvloop](https://pypi.org/project/uvloop/0.23.0/) | 0.23.0 | MIT; also ships Apache-2.0 license text |
| [watchfiles](https://pypi.org/project/watchfiles/1.3.0/) | 1.3.0 | MIT |
| [websockets](https://pypi.org/project/websockets/17.4/) | 17.4 | BSD-3-Clause |

`hatchling` is also declared as the Python build backend in `pyproject.toml`, under MIT. Its version and isolated build dependencies are not pinned in `uv.lock`, so the table does not inventory that separate build environment. See [Hatchling package metadata](https://pypi.org/project/hatchling/).

## Fonts and original assets

- The frontend requests DM Sans and Playfair Display through Google Fonts. Their font software uses SIL Open Font License 1.1 (`OFL-1.1`): [DM Sans license](https://github.com/google/fonts/blob/main/ofl/dmsans/OFL.txt), [Playfair Display license](https://github.com/google/fonts/blob/main/ofl/playfairdisplay/OFL.txt). Font binaries are not bundled in the source snapshot.
- Demo prose, fixtures, generated cocktail/ingredient/tool illustrations and fictional avatars are documented in [`db/seeds/`](db/seeds/README.md). The favicon is an original SVG. The imported recipe cache and template logo graphics are no longer bundled.

## Separate prototype

The Rails prototype has its own dependencies in `shakestir-rails/Gemfile` and `Gemfile.lock`; they are outside this inventory and the upload snapshot. Its vendored Semanticus stylesheet retains license and notice files under `shakestir-rails/vendor/semanticus/`. Do not apply the Python/React inventory to a distribution that includes the prototype.

## Redistribution

Retain the applicable upstream license and copyright notices if distributing dependency code or compiled bundles. MIT requires its notice to accompany copies or substantial portions; Apache-2.0 has license and applicable NOTICE requirements. These references explain the conditions: [MIT](https://opensource.org/license/mit), [Apache-2.0](https://www.apache.org/licenses/LICENSE-2.0), [MPL-2.0](https://www.mozilla.org/en-US/MPL/2.0/). A link or inventory alone does not fulfill every redistribution condition.

The generated source ZIP contains dependency manifests and lockfiles rather than installed dependency code. Production bundles, wheels, containers and platform-specific installations require their own review of the dependencies and notices actually distributed.
