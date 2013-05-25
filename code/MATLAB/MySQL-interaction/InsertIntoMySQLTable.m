function InsertIntoMySQLTable(conn,frontVal,topVal,sideVal)

if isconnection(conn)
     qry = sprintf('INSERT INTO faces(front,top,side) VALUES(%s,%s,%s);',frontVal,topVal,sideVal);
    display(qry);
    fetch(exec(conn, qry));
else
    display('MySql Connection Error');
end