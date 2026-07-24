function ArrayToCsv( DataArray){
    if (!DataArray || DataArray.length === 0) return '';
    var headers = Object.keys(DataArray[0]);
    var lineas = [headers.join(',')];
    for (var i = 0; i < DataArray.length; i++) {
        var fila = headers.map(function(h) { return DataArray[i][h]; });
        lineas.push(fila.join(','));
    }
    return lineas.join('\n');
}