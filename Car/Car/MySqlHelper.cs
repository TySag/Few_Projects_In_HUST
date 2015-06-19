using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data.OleDb;
using System.Data;
using System.Configuration;
using System.Data.Sql;
using MySql.Data.MySqlClient;

namespace Car
{
    class MySqlHelper
    {
        private MySqlConnection con;
        public string user;
        public string pass;
        public string database;
        // close a con
        public MySqlHelper(string user, string pass, string database)
        {
            this.user = user;
            this.pass = pass;
            this.database = database;
        }
        public void Close(){
            if (con != null)
            {
                con.Close();
                con.Dispose();
            }
        }
        private void Open()// 打开连接池 
        {
            
            if (con == null)
            {
                //这里不仅需要using System.Configuration;还要在引用目录里添加 
                con = new MySqlConnection(SqlConstring());
                con.Open();
            }
        }
        public void Dispose()
        {
            // 确定连接已关闭 
            if (con != null)
            {
                con.Dispose();
                con = null;
            }
        } 
        //create a Mysqlcommand
        private MySqlCommand CreateCommand(string procName, MySqlParameter[] prams)
        {
            Open();// 确定连接是打开的
            MySqlCommand cmd = new MySqlCommand(procName, con);
            cmd.CommandType = CommandType.StoredProcedure;
            if (prams != null)// 添加存储过程的输入参数列表
            {
                foreach (MySqlParameter parameter in prams)
                    cmd.Parameters.Add(parameter);
            }
            return cmd;
        } 

        private string SqlConstring(){
            string str_sqlcon = "server=localhost;Uid=";
            str_sqlcon+=user;
            str_sqlcon+=";Pwd=";
            str_sqlcon+=pass;
            str_sqlcon+=";Database=";
            str_sqlcon+=database;
            return str_sqlcon;
        }
        public bool Connect()
        {
            string consql = SqlConstring();
            con = new MySqlConnection(consql);
            try
            {
                con.Open();
                con.Close();
            }
            catch(Exception e)
            {
                string s = e.ToString();
                return false;
            }
            return true;
        }
        public int ExecuteSql(string sqlword)
        {
            string consql = SqlConstring();
            con = new MySqlConnection(consql);
            MySqlCommand cmd = new MySqlCommand();
            cmd.Connection = con;
            cmd.CommandText = sqlword;
            con.Open();
            cmd.ExecuteNonQuery();
            cmd.Dispose();
            con.Close();
            con.Dispose();
            return 1;
        }
        public int ExecuteSql(string sqlword, MySqlParameter[] param)
        {
            string consql = SqlConstring();
            con = new MySqlConnection(consql);
            MySqlCommand cmd = new MySqlCommand();
            cmd.Connection = con;
            cmd.CommandText = sqlword;
            cmd.Parameters.AddRange(param);
            con.Open();
            cmd.ExecuteNonQuery();
            con.Close();
            return 1;
        }
        public MySqlDataReader ExecuteReader(string sqlword)
        {
            string consql = SqlConstring();
            con = new MySqlConnection(consql);
            try
            {
                MySqlCommand cmd = new MySqlCommand();
                cmd.Connection = con;
                cmd.CommandText = sqlword;
                con.Open();
                return cmd.ExecuteReader(CommandBehavior.CloseConnection);
            }
            catch{//exception
                return null;
            }
        }
        public DataTable ExecuteDt(string sqlword) {
            string consql = SqlConstring();
            con = new MySqlConnection(consql);
            MySqlDataAdapter da = new MySqlDataAdapter(sqlword, con);
            DataTable dt = new DataTable();
            con.Open();
            try
            {
                da.Fill(dt);
            }
            catch
            {
                dt = null;
            }
            con.Close();
            return dt;
        }

        public void SyncSql(DataTable dt, string sqlword)
        {
            string consql = SqlConstring();
            con = new MySqlConnection(consql);
            MySqlDataAdapter da = new MySqlDataAdapter(sqlword, con);
            da.SelectCommand = new MySqlCommand(sqlword, con);
            MySqlCommandBuilder mybuilder = new MySqlCommandBuilder(da);
            //con.Open();
            da.Update(dt);
            //con.Close();
        }

        public DataSet ExecuteDs(string sqlword){
            string consql = SqlConstring();
            con = new MySqlConnection(consql);
            MySqlDataAdapter da = new MySqlDataAdapter(sqlword, con);
            DataSet ds = new DataSet();
            con.Open();
            da.Fill(ds);
            con.Close();
            return ds;
        }
        //存储过程的名字<get value>
        public int RunProc(string procName)
        {
            MySqlCommand cmd = CreateCommand(procName, null);
            cmd.ExecuteNonQuery();
            cmd.Dispose();
            this.Close();
            return (int)cmd.Parameters["ReturnValue"].Value;
        }
        //结果集
        public void RunProc(string procName, out MySqlDataReader dataReader)
        {
            MySqlCommand cmd = CreateCommand(procName, null);
            dataReader = cmd.ExecuteReader(CommandBehavior.CloseConnection);
        }
        //存储过程的输入参数列表
        public void RunProc(string procName, MySqlParameter[] prams, out MySqlDataReader dataReader)
        {
            MySqlCommand cmd = CreateCommand(procName, prams);
            dataReader = cmd.ExecuteReader(CommandBehavior.CloseConnection);
        }
        public MySqlParameter MakeParam(string ParamName, MySqlDbType DbType, Int32 Size, ParameterDirection Direction, object Value)
        {
            MySqlParameter param;
            if (Size > 0)
            {
                param = new MySqlParameter(ParamName, DbType, Size);
            }
            else
            {
                param = new MySqlParameter(ParamName, DbType);
            }
            param.Direction = Direction;
            if (!(Direction == ParameterDirection.Output && Value == null))
            {
                param.Value = Value;
            }
            return param;
        } 
        //创建输入参数 
        //新参数对象 <- 参数名 参数类型 参数大小 参数值
        public MySqlParameter MakeInParam(string ParamName, MySqlDbType DbType, int Size, object Value)
        {
            return MakeParam(ParamName, DbType, Size, ParameterDirection.Input, Value);
        }
       
        // 创建输出参数 
        //新参数对象 <- 参数名 参数类型 参数大小
        public MySqlParameter MakeOutParam(string ParamName, MySqlDbType DbType, int Size)
        {
            return MakeParam(ParamName, DbType, Size, ParameterDirection.Output, null);
        }

        


    }
}
