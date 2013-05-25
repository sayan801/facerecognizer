function InsertIntoMySQLTableRecursive(conn,tableName,colArr,dataArr)

maxIndex = length(dataArr);

if isconnection(conn)
    columnFields = colArr(1);
    dataFields = dataArr(1);
    for i = 2: maxIndex
        colInput = colArr(i);
    columnFields = sprintf('%s,%s',columnFields,colInput);
    dataInput = dataArr(i);
    dataFields = sprintf('%s,%s',dataFields,dataInput);
    end
    display(columnFields);
    display(dataFields);
    
    qry = sprintf('INSERT INTO %s(%s) VALUES(%s);',tableName,columnFields,dataFields);
    display(qry);
else
    display('MySql Connection Error');
end