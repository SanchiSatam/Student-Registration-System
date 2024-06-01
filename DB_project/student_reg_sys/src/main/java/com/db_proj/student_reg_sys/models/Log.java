package com.db_proj.student_reg_sys.models;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;
import java.util.Date;

@Entity
@Table(name = "logs")
public class Log {
    @Id
    @Column(name = "log#")
    private int logNumber;

    @Column(name = "user_name")
    private String userName;

    @Column(name = "op_time")
    private Date operationTime;

    @Column(name = "table_name")
    private String tableName;

    private String operation;

    @Column(name = "tuple_keyvalue")
    private String tupleKeyValue;

    // Getters and setters
    public int getLogNumber() {
        return logNumber;
    }

    public void setLogNumber(int logNumber) {
        this.logNumber = logNumber;
    }

    public String getUserName() {
        return userName;
    }

    public void setUserName(String userName) {
        this.userName = userName;
    }

    public Date getOperationTime() {
        return operationTime;
    }

    public void setOperationTime(Date operationTime) {
        this.operationTime = operationTime;
    }

    public String getTableName() {
        return tableName;
    }

    public void setTableName(String tableName) {
        this.tableName = tableName;
    }

    public String getOperation() {
        return operation;
    }

    public void setOperation(String operation) {
        this.operation = operation;
    }

    public String getTupleKeyValue() {
        return tupleKeyValue;
    }

    public void setTupleKeyValue(String tupleKeyValue) {
        this.tupleKeyValue = tupleKeyValue;
    }
}
