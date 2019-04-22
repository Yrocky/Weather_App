navigator.accelerometer = {
  getCurrentAcceleration: function(onSuccess, onError) {
    Queue.push(Task.init(Queue.length, onSuccess, onError));
    window.webkit.messageHandlers.MMWebViewPlugin.postMessage({className: 'MMAccelerometerPlugin', functionName: 'getCurrentAcceleration', taskId: Queue.length - 1});
  }
}
