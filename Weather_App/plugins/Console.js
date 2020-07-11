console = {
  log: function (string) {
    window.webkit.messageHandlers.MMWebViewPlugin.postMessage({className: 'MMConsolePlugin', functionName: 'log', data: string});
  }
}
