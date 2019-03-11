({
    getDifference : function(oldValue, newValue) {
    var result = [];
    for (var i = 0; i < newValue.length; i++) {
        if (oldValue.indexOf(newValue[i]) === -1) {
            result.push(newValue[i]);
        }
    }
    for (i = 0; i < oldValue.length; i++) {
        if (newValue.indexOf(oldValue[i]) === -1) {
            result.push(oldValue[i]);
        }
    }
    return result;
}
})