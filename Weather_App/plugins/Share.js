Share = {
    wechat: function (string) {
        window.webkit.messageHandlers.MMWebViewPlugin.postMessage({className: 'MMSharePlugin', functionName: 'wechat', data: string});
    },
    qq: function (string) {
        window.webkit.messageHandlers.MMWebViewPlugin.postMessage({className: 'MMSharePlugin', functionName: 'qq', data: string});
    },
    // 有回调的方法，可以将分享的结果通知js
    qq2: function (msg, onSuccess, onError) {
        Queue.push(Task.init(Queue.length, onSuccess, onError));
        // 这里异步执行
        window.webkit.messageHandlers.MMWebViewPlugin.postMessage({className: 'MMSharePlugin', functionName: 'qq2', data: msg, taskId: Queue.length - 1});
    },
    qq3: function (msg, onSuccess, onError) {
        onSuccess(msg);
    }
}
