using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Net.Mail;
using System.Timers;

namespace Status_Tracker
{
    class TaskInfo
    {
        public string id = "";
        public string description = "";
        public string date = "";
        public string isCompleted = "";
        public string name = "";
        public string category = "";
        public string color = "";
    }

    class EventInfo
    {
        public string id = "";
        public string description = "";
        public string category = "";
        public string startDate = "";
        public string endDate = "";
    }

    internal class Program
    {
        static System.Timers.Timer timer = null;
        static SqlConnection _sqlConn;
        static void Main(string[] args)
        {
            Console.WriteLine("Please wait 10 seconds...");
            timer = new System.Timers.Timer(10000);
            timer.Elapsed += OnTimerEvent;
            timer.AutoReset = true;
            timer.Enabled = true;
            Console.ReadLine();
        }
        static public void OpenDBConnection()
        {
            if (_sqlConn == null)
            {
                _sqlConn = new SqlConnection("Server=DESKTOP-6ITJ6Q2\\SQLEXPRESS;Database=Scheduler;Integrated Security=SSPI;");
                _sqlConn.Open();
            }
        }

        static public void CloseDBConnection()
        {
            if (_sqlConn != null)
            {
                _sqlConn.Close();
            }
        }

        static public void OnTimerEvent(Object source, ElapsedEventArgs e)
        {
            Console.Clear();
            GetTaskReminder();
            GetEventReminder();
            Console.WriteLine("Please wait 10 seconds...");
        }

        static public void GetTaskReminder()
        {
            SqlDataReader sqlReader = null;
            try
            {
                Console.WriteLine("Checking for task statuses...");
                OpenDBConnection();
                SqlCommand sqlCmd = _sqlConn.CreateCommand();
                sqlCmd.CommandType = System.Data.CommandType.StoredProcedure;
                sqlCmd.CommandText = "GetTaskReminder";
                sqlReader = sqlCmd.ExecuteReader();
                List<TaskInfo> tasksList = new List<TaskInfo>();
                Console.Write("Done.\n");
                if (sqlReader.HasRows)
                {
                    Console.WriteLine("Sending notification for tasks: ");
                    while (sqlReader.Read())
                    {
                        TaskInfo taskInfo = new TaskInfo();
                        taskInfo.id = sqlReader.GetValue(0).ToString();
                        taskInfo.description = sqlReader.GetValue(1).ToString();
                        taskInfo.date = sqlReader.GetValue(2).ToString();
                        taskInfo.category = sqlReader.GetValue(3).ToString();
                        taskInfo.color = sqlReader.GetValue(4).ToString();
                        taskInfo.isCompleted = sqlReader.GetValue(5).ToString();
                        taskInfo.name = sqlReader.GetValue(6).ToString();
                        tasksList.Add(taskInfo);
                        SendTaskNotification(taskInfo);
                        Console.WriteLine(taskInfo.name + '\n');
                    }
                    Console.WriteLine("Notification sent");
                }
                sqlReader.Close();
                for (int i = 0; i < tasksList.Count; i++)
                {
                    sqlCmd.CommandText = "UpdateTaskReminder";
                    sqlCmd.Parameters.Clear();
                    sqlCmd.Parameters.AddWithValue("@taskId", tasksList[i].id);
                    sqlCmd.ExecuteNonQuery();
                }
            }
            catch (Exception ex)
            {
                Console.Write(ex.Message);
            }
            finally
            {
                if (sqlReader != null)
                {
                    sqlReader.Close();
                }
            }
        }

        static public void GetEventReminder()
        {
            SqlDataReader sqlReader = null;
            try
            {
                Console.WriteLine("Checking for event statuses...");
                OpenDBConnection();
                SqlCommand sqlCmd = _sqlConn.CreateCommand();
                sqlCmd.CommandType = System.Data.CommandType.StoredProcedure;
                sqlCmd.CommandText = "GetEventReminder";
                sqlReader = sqlCmd.ExecuteReader();
                List<EventInfo> eventsList = new List<EventInfo>();
                Console.Write("Done.\n");
                if (sqlReader.HasRows)
                {
                    Console.WriteLine("Sending notification for events: ");
                    while (sqlReader.Read())
                    {
                        EventInfo eventInfo = new EventInfo();
                        eventInfo.id = sqlReader.GetValue(0).ToString();
                        eventInfo.description = sqlReader.GetValue(1).ToString();
                        eventInfo.startDate = sqlReader.GetValue(2).ToString();
                        eventInfo.endDate = sqlReader.GetValue(3).ToString();
                        eventInfo.category = sqlReader.GetValue(4).ToString();
                        eventsList.Add(eventInfo);
                        SendEventNotification(eventInfo);
                        Console.WriteLine(eventInfo.description + '\n');
                    }
                    Console.WriteLine("Notification sent");
                }
                sqlReader.Close();
                for (int i = 0; i < eventsList.Count; i++)
                {
                    sqlCmd.CommandText = "UpdateEventReminder";
                    sqlCmd.Parameters.Clear();
                    sqlCmd.Parameters.AddWithValue("@eventId", eventsList[i].id);
                    sqlCmd.ExecuteNonQuery();
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine(ex.Message);
            }
            finally
            {
                if (sqlReader != null)
                {
                    sqlReader.Close();
                }
            }
        }

        static public void SendEventNotification(EventInfo eventInfo)
        {
            try
            {
                string sender = "johndoe.cs180@gmail.com";
                string recipient = "johndoe.cs180@gmail.com";
                string subject = eventInfo.description;
                string body = eventInfo.startDate + "\n"
                            + eventInfo.endDate + "\n"
                            + eventInfo.category + "\n";
                MailMessage mailMsg = new MailMessage(sender, recipient, subject, body);

                SmtpClient smtp = new SmtpClient("smtp.gmail.com", 587);
                smtp.EnableSsl = true;
                smtp.UseDefaultCredentials = false;
                smtp.Credentials = new System.Net.NetworkCredential("johndoe.cs180@gmail.com", "epciylghtstdnvzr");
                smtp.Send(mailMsg);
            }
            catch (Exception ex)
            {
                Console.Write(ex.Message);
            }
        }


        static public void SendTaskNotification(TaskInfo taskInfo)
        {
            try
            {
                string sender = "johndoe.cs180@gmail.com";
                string recipient = "johndoe.cs180@gmail.com";
                string subject = taskInfo.name;
                string body = taskInfo.description + "\n"
                            + taskInfo.date + "\n"
                            + taskInfo.isCompleted + "\n"
                            + taskInfo.category + "\n"
                            + taskInfo.color;
                MailMessage mailMsg = new MailMessage(sender, recipient, subject, body);

                SmtpClient smtp = new SmtpClient("smtp.gmail.com", 587);
                smtp.EnableSsl = true;
                smtp.UseDefaultCredentials = false;
                smtp.Credentials = new System.Net.NetworkCredential("johndoe.cs180@gmail.com", "epciylghtstdnvzr");
                smtp.Send(mailMsg);
            }
            catch (Exception ex)
            {
                Console.Write(ex.Message);
            }
        }
    }
}
