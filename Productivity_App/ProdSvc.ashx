<%@ WebHandler Language="C#" Class="ProdSvc" %>

using System;
using System.Web;
using System.Data.SqlClient;

public class ProdSvc : IHttpHandler
{
    SqlConnection _sqlConn;

    public void ProcessRequest(HttpContext context)
    {
        context.Response.ContentType = "text/plain";

        try
        {
            string reqCmd = (context.Request["Req_Cmd"] + "").ToUpper();
            switch (reqCmd)
            {
                case "DELETE_EVENT_INFO":
                    context.Response.Write(DeleteEventInfo(context.Request["Event_Id"]));
                    break;

                case "GET_EVENT_INFO":
                    context.Response.Write(GetEventInfo(context.Request["Event_Id"]));
                    break;

                case "DELETE_TASK_INFO":
                    context.Response.Write(DeleteTaskInfo(context.Request["Task_Id"]));
                    break;

                case "GET_TASK_INFO":
                    context.Response.Write(GetTaskInfo(context.Request["Task_Id"]));
                    break;

                case "GET_EVENT_LIST":
                    context.Response.Write(GetEventList(context.Request["Display_Type_Id"]));
                    break;

                case "GET_TASK_LIST":
                    context.Response.Write(GetTaskList(context.Request["Display_Type_Id"]));
                    break;

                case "SAVE_EVENT_INFO":
                    context.Response.Write(SaveEventInfo(
                    context.Request["Event_Id"],
                    context.Request["Event_Description"],
                    context.Request["Event_Category"],
                    context.Request["Start_Date"],
                    context.Request["End_Date"]
                    ));
                    break;

                case "SAVE_TASK_INFO":
                    context.Response.Write(SaveTaskInfo(
                    context.Request["Task_Id"],
                    context.Request["Task_Name"],
                    context.Request["Task_Description"],
                    context.Request["Task_Category"],
                    context.Request["Task_Date"],
                    context.Request["Completion_Status"],
                    context.Request["Color"]
                    ));
                    break;

            }
        }
        catch (Exception e)
        {
            context.Response.Write(SqlReaderToJSON(null, e.Message, false));
        }
        finally
        {
            CloseDBConnection();
        }
    }

    public void OpenDBConnection()
    {
        if (_sqlConn == null)
        {
            _sqlConn = new SqlConnection("Server=DESKTOP-6ITJ6Q2\\SQLEXPRESS;Database=Scheduler;Integrated Security=SSPI;");
            _sqlConn.Open();
        }
    }

    public void CloseDBConnection()
    {
        if (_sqlConn != null)
        {
            _sqlConn.Close();
        }
    }

    public string SaveEventInfo(string eventId, string eventDescription, string eventCategory, string startDate, string endDate)
    {
        SqlDataReader sqlReader = null;
        string jsonTxt = "";
        try
        {
            OpenDBConnection();
            SqlCommand sqlCmd = _sqlConn.CreateCommand();
            sqlCmd.CommandType = System.Data.CommandType.StoredProcedure;
            sqlCmd.CommandText = "SaveEventInfo";
            sqlCmd.Parameters.AddWithValue("@eventId", eventId);
            sqlCmd.Parameters.AddWithValue("@description", eventDescription);
            sqlCmd.Parameters.AddWithValue("@category", eventCategory);
            sqlCmd.Parameters.AddWithValue("@startDate", startDate);
            sqlCmd.Parameters.AddWithValue("@endDate", endDate);
            sqlReader = sqlCmd.ExecuteReader();
            sqlReader.Close();
        }
        catch (Exception e)
        {
            jsonTxt = SqlReaderToJSON(null, e.Message, false);
        }
        finally
        {
            if (sqlReader != null)
            {
                sqlReader.Close();
            }
        }
        return "";
    }

    public string SaveTaskInfo(
        string taskId,
        string taskName,
        string taskDescription,
        string taskCategory,
        string taskDate,
        string completionStatus,
        string color)
    {
        SqlDataReader sqlReader = null;
        string jsonTxt = "";
        try
        {
            OpenDBConnection();
            SqlCommand sqlCmd = _sqlConn.CreateCommand();
            sqlCmd.CommandType = System.Data.CommandType.StoredProcedure;
            sqlCmd.CommandText = "SaveTaskInfo";
            sqlCmd.Parameters.AddWithValue("@taskId", taskId);
            sqlCmd.Parameters.AddWithValue("@name", taskName);
            sqlCmd.Parameters.AddWithValue("@description", taskDescription);
            sqlCmd.Parameters.AddWithValue("@category", taskCategory);
            sqlCmd.Parameters.AddWithValue("@completionStatus", completionStatus);
            sqlCmd.Parameters.AddWithValue("@date", taskDate);
            sqlCmd.Parameters.AddWithValue("@color", color);
            sqlReader = sqlCmd.ExecuteReader();
            sqlReader.Close();
        }
        catch (Exception e)
        {
            jsonTxt = SqlReaderToJSON(null, e.Message, false);

        }
        finally
        {
            if (sqlReader != null)
            {
                sqlReader.Close();
            }
        }
        return "";
    }
    public string DeleteTaskInfo(string taskId)
    {
        string jsonTxt = "";
        try
        {
            OpenDBConnection();
            SqlCommand sqlCmd = _sqlConn.CreateCommand();
            sqlCmd.CommandType = System.Data.CommandType.StoredProcedure;
            sqlCmd.CommandText = "DeleteTaskInfo";
            sqlCmd.Parameters.AddWithValue("@taskId", taskId);
            sqlCmd.ExecuteNonQuery();
            jsonTxt = SqlReaderToJSON(null, "", false);
        }
        catch (Exception e)
        {
            jsonTxt = SqlReaderToJSON(null, e.Message, false);
        }
        return jsonTxt;
    }

    public string DeleteEventInfo(string eventId)
    {
        string jsonTxt = "";
        try
        {
            OpenDBConnection();
            SqlCommand sqlCmd = _sqlConn.CreateCommand();
            sqlCmd.CommandType = System.Data.CommandType.StoredProcedure;
            sqlCmd.CommandText = "DeleteEventInfo";
            sqlCmd.Parameters.AddWithValue("@eventId", eventId);
            sqlCmd.ExecuteNonQuery();
            jsonTxt = SqlReaderToJSON(null, "", false);
        }
        catch (Exception e)
        {
            jsonTxt = SqlReaderToJSON(null, e.Message, false);
        }
        return jsonTxt;
    }

    public string GetEventInfo(string eventId)
    {
        SqlDataReader sqlReader = null;
        string jsonTxt = "";
        try
        {
            OpenDBConnection();
            SqlCommand sqlCmd = _sqlConn.CreateCommand();
            sqlCmd.CommandType = System.Data.CommandType.StoredProcedure;
            sqlCmd.CommandText = "GetEventInfo";
            sqlCmd.Parameters.AddWithValue("@eventId", eventId);
            sqlReader = sqlCmd.ExecuteReader();

            jsonTxt = SqlReaderToJSON(sqlReader, "", false);
            sqlReader.Close();
        }
        catch (Exception e)
        {
            jsonTxt = SqlReaderToJSON(null, e.Message, false);
        }
        finally
        {
            if (sqlReader != null)
            {
                sqlReader.Close();
            }
        }
        return jsonTxt;
    }

    public string GetTaskInfo(string taskId)
    {
        SqlDataReader sqlReader = null;
        string jsonTxt = "";
        try
        {
            OpenDBConnection();
            SqlCommand sqlCmd = _sqlConn.CreateCommand();
            sqlCmd.CommandType = System.Data.CommandType.StoredProcedure;
            sqlCmd.CommandText = "GetTaskInfo";
            sqlCmd.Parameters.AddWithValue("@taskId", taskId);
            sqlReader = sqlCmd.ExecuteReader();

            jsonTxt = SqlReaderToJSON(sqlReader, "", false);
            sqlReader.Close();
        }
        catch (Exception e)
        {
            jsonTxt = SqlReaderToJSON(null, e.Message, false);
        }
        finally
        {
            if (sqlReader != null)
            {
                sqlReader.Close();
            }
        }
        return jsonTxt;
    }

    public string GetEventList(string displayTypeId)
    {
        SqlDataReader sqlReader = null;
        string jsonTxt = "";
        try
        {
            OpenDBConnection();
            SqlCommand sqlCmd = _sqlConn.CreateCommand();
            sqlCmd.CommandType = System.Data.CommandType.StoredProcedure;
            sqlCmd.CommandText = "GetEventList";
            sqlCmd.Parameters.AddWithValue("@displayTypeId", displayTypeId);
            sqlReader = sqlCmd.ExecuteReader();

            jsonTxt = SqlReaderToJSON(sqlReader, "", true);
            sqlReader.Close();
        }
        catch (Exception e)
        {
            jsonTxt = SqlReaderToJSON(null, e.Message, true);
        }
        finally
        {
            if (sqlReader != null)
            {
                sqlReader.Close();
            }
        }
        return jsonTxt;
    }

    public string GetTaskList(string displayTypeId)
    {
        SqlDataReader sqlReader = null;
        string jsonTxt = "";

        try
        {
            OpenDBConnection();
            SqlCommand sqlCmd = _sqlConn.CreateCommand();
            sqlCmd.CommandType = System.Data.CommandType.StoredProcedure;
            sqlCmd.CommandText = "GetTaskList";
            sqlCmd.Parameters.AddWithValue("@displayTypeId", displayTypeId);
            sqlReader = sqlCmd.ExecuteReader();

            jsonTxt = SqlReaderToJSON(sqlReader, "", true);
            sqlReader.Close();
        }
        catch (Exception e)
        {
            jsonTxt = SqlReaderToJSON(null, e.Message, true);
        }
        finally
        {
            if (sqlReader != null)
            {
                sqlReader.Close();
            }
        }
        return jsonTxt;
    }

    public string SqlReaderToJSON(SqlDataReader sqlReader, string errorMessage, bool isList)
    {
        string dataTxt = "";
        string jsonTxt = "";
        if (errorMessage == "" && sqlReader != null)
        {
            int colCount = sqlReader.FieldCount;
            if (sqlReader.HasRows)
            {
                while (sqlReader.Read())
                {
                    dataTxt += "{";
                    for (int j = 0; j < colCount; j++)
                    {
                        dataTxt += "\"" + sqlReader.GetName(j) + "\":\"" + System.Web.HttpUtility.JavaScriptStringEncode(sqlReader.GetValue(j).ToString()) + "\",";
                    }
                    dataTxt += "},";
                }
            }
            dataTxt = dataTxt.Replace(",}", "}");
        }
        if (isList == true)
        {
            jsonTxt = "{ \"error\": \"" + errorMessage + "\",\"data\":[" + dataTxt + "]}";
        }
        else
        {
            jsonTxt = "{ \"error\": \"" + errorMessage + "\",\"data\": " + (dataTxt == "" ? "{}" : dataTxt) + "}";
        }
        jsonTxt = jsonTxt.Replace(",]}", "]}").Replace(",}", "}");
        return jsonTxt;
    }

    public bool IsReusable
    {
        get
        {
            return false;
        }
    }

}