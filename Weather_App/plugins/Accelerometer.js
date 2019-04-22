navigator.accelerometer = {
  getCurrentAcceleration: function(onSuccess, onError) {
    Queue.push(Task.init(Queue.length, onSuccess, onError));
    window.webkit.messageHandlers.MMWebViewPlugin.postMessage({className: 'MMAccelerometerPlugin', functionName: 'getCurrentAcceleration', taskId: Queue.length - 1});
  }
}
// navigator 是js中的一个全局对象，里面有以下这些属性，其中的 accelerometer 就是通过添加插件注入的一个对象
// 所以这个js文件的作用是为已有对象添加一个属性，这个属性是叫做 accelerometer 的对象，这个对象中有一个 getCurrentAcceleration 方法，方法接收两个参数，用来做异步回调

/*
accelerometer: {getCurrentAcceleration: function}
appCodeName: "Mozilla"
appName: "Netscape"
appVersion: "5.0 (iPhone; CPU iPhone OS 12_1_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/16C101"
cookieEnabled: true
geolocation: Geolocation {getCurrentPosition: function, watchPosition: function, clearWatch: function}
language: "zh-CN"
languages: ["zh-CN"] (1)
mimeTypes: MimeTypeArray {length: 0, item: function, namedItem: function}
onLine: true
platform: "iPhone"
plugins: PluginArray {length: 0, item: function, namedItem: function, refresh: function}
product: "Gecko"
productSub: "20030107"
standalone: false
userAgent: "Mozilla/5.0 (iPhone; CPU iPhone OS 12_1_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/16C101"
vendor: "Apple Computer, Inc."
vendorSub: ""
webdriver: false
*/
