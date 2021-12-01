
Qts <- function(x) {
  if (grepl('^\\\".*\\\"$', x)) {
    return(x)
  } else {
    return(paste0('"',x,'"'))
  }
}

make_package_json <- function(name,
                              version,
                              description,
                              out = here::here(),
                              keywords = "",
                              author = "",
                              license = "MIT",
                              devDependencies = list(`electron-packager` = "^15.4.0")) {

  elect_version <- gsub("^v", "", system("electron --version", intern = T, wait = T))
  elect_pkgr <- gsub("^Electron Packager ", "^", system("electron-packager --version", intern = T, wait = T)[1])
  glue::glue(
    .open = "<", .close = ">",
    '
    {
      "name": <Qts(name)>,
      "version": <Qts(version)>,
      "description": <Qts(description)>,
      "main": "main.js",
      "scripts": {
        "start": "electron .",
        "package-mac": "electron-packager . --overwrite --platform=darwin --arch=x64 --out=<out> --electron-version=<elect_version>",
        "package-win": "electron-packager . --overwrite --platform=win32 --arch=ia32 --icon=cc.ico --out=<out> --version-string.ProductName="Shiny Electron App" --electron-version=<elect_version>,
        "package-linux": "electron-packager . --overwrite --platform=linux --arch=x64 --prun=true --out=<out> --electron-version=<elect_version>
      },
      "keywords": [
        <glue_collapse(vapply(keywords, Qts, character(1L)), sep = ",\n        ")>
      ],
      "author": <author>,
      "license": <license>,
      "devDependencies": {
        "electron": <paste0("^", elect_version)>,
        "electron-packager <elect_pkgr>"
      }
    }')
}
