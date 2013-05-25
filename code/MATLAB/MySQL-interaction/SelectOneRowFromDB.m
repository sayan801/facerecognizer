function alldata =   SelectOneRowFromDB(conn,tableName,colName,value)

if isconnection(conn)
    qry = sprintf('Select * From %s where %s = %s;',tableName,colName,value);
    display(qry);
    rs = fetch(exec(conn, qry));
    alldata = get(rs, 'Data');
    display(alldata);
else
    display('MySql Connection Error');
end