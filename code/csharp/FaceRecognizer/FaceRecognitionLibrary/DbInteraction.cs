//using System;
//using System.Collections.Generic;
//using System.Linq;
//using System.Text;

//namespace FaceRecognitionLibrary
//{
//    using System;
//    using System.Collections.Generic;
//    using System.Linq;
//    using System.Text;

//        public class DbInteraction
//        {
//            static string passwordCurrent = "technicise";
//            static string dbmsCurrent = "FaceRecognizerdb";

//            /// <summary>
//            /// Opens the database connection.
//            /// </summary>
//            /// <returns></returns>
//            private static MySql.Data.MySqlClient.MySqlConnection OpenDbConnection()
//            {
//                MySql.Data.MySqlClient.MySqlConnection msqlConnection = null;

//                msqlConnection = new MySql.Data.MySqlClient.MySqlConnection("server=localhost;user id=root;Password=" + passwordCurrent + ";database=" + dbmsCurrent + ";persist security info=False");

//                //open the connection
//                if (msqlConnection.State != System.Data.ConnectionState.Open)
//                    msqlConnection.Open();

//                return msqlConnection;
//            }

//            #region User

//            public static int DoRegisterNewUser(UserInfo NewUser)
//            {
//                return DoRegisterNewuserindb(NewUser);
//            }

//            private static int DoRegisterNewuserindb(UserInfo NewUser)
//            {
//                int returnVal = 0;
//                MySql.Data.MySqlClient.MySqlConnection msqlConnection = OpenDbConnection();

//                try
//                {
//                    //define the command reference
//                    MySql.Data.MySqlClient.MySqlCommand msqlCommand = new MySql.Data.MySqlClient.MySqlCommand();

//                    //define the connection used by the command object
//                    msqlCommand.Connection = msqlConnection;

//                    msqlCommand.CommandText = "INSERT INTO user(id,userid,passwrd,hints) " + "VALUES(@id,@userid,@passwrd,@hints)";

//                    msqlCommand.Parameters.AddWithValue("@id", NewUser.userId);
//                    msqlCommand.Parameters.AddWithValue("@userid", NewUser.userId);
//                    msqlCommand.Parameters.AddWithValue("@passwrd", NewUser.userName);
//                    msqlCommand.Parameters.AddWithValue("@hints", NewUser.ImageOwned);


//                    msqlCommand.ExecuteNonQuery();

//                    returnVal = 1;
//                }
//                catch (Exception er)
//                {
//                    returnVal = 0;
//                }
//                finally
//                {
//                    //always close the connection
//                    msqlConnection.Close();
//                }
//                return returnVal;
//            }

//            #endregion

//            #region ID password

//            public static string FetcheId()
//            {

//                string idStr = string.Empty;

//                int returnVal = 0;
//                MySql.Data.MySqlClient.MySqlConnection msqlConnection = OpenDbConnection();

//                try
//                {


//                    //define the command reference
//                    MySql.Data.MySqlClient.MySqlCommand msqlCommand = new MySql.Data.MySqlClient.MySqlCommand();

//                    //define the connection used by the command object
//                    msqlCommand.Connection = msqlConnection;


//                    msqlCommand.CommandText = "Select userid from user;";
//                    MySql.Data.MySqlClient.MySqlDataReader msqlReader = msqlCommand.ExecuteReader();

//                    msqlReader.Read();

//                    idStr = msqlReader.GetString("userid");

//                }
//                catch (Exception er)
//                {
//                    //Assert//.Show(er.Message);
//                }
//                finally
//                {
//                    //always close the connection
//                    msqlConnection.Close();
//                }

//                return idStr;
//            }

//            public static string FetchePassword()
//            {

//                string passwordStr = string.Empty;

//                int returnVal = 0;
//                MySql.Data.MySqlClient.MySqlConnection msqlConnection = OpenDbConnection();

//                try
//                {


//                    //define the command reference
//                    MySql.Data.MySqlClient.MySqlCommand msqlCommand = new MySql.Data.MySqlClient.MySqlCommand();

//                    //define the connection used by the command object
//                    msqlCommand.Connection = msqlConnection;


//                    msqlCommand.CommandText = "Select passwrd from user;";
//                    MySql.Data.MySqlClient.MySqlDataReader msqlReader = msqlCommand.ExecuteReader();

//                    msqlReader.Read();

//                    passwordStr = msqlReader.GetString("passwrd");

//                }
//                catch (Exception er)
//                {
//                    //Assert//.Show(er.Message);
//                }
//                finally
//                {
//                    //always close the connection
//                    msqlConnection.Close();
//                }

//                return passwordStr;
//            }
//            #endregion

//            #region Image


//            public static int DoRegisterNewImage(StorageImageInfo ImageDetails)
//            {
//                int returnVal = 0;
//                MySql.Data.MySqlClient.MySqlConnection msqlConnection = OpenDbConnection();

//                try
//                {
//                    //define the command reference
//                    MySql.Data.MySqlClient.MySqlCommand msqlCommand = new MySql.Data.MySqlClient.MySqlCommand();

//                    //define the connection used by the command object
//                    msqlCommand.Connection = msqlConnection;

//                    msqlCommand.CommandText = "INSERT INTO Image(ImageId,lastScannedDate,lastUsedHost,files,remark) "
//                                                       + "VALUES(@ImageId,@lastScannedDate,@lastUsedHost,@files,@filesBackupHere,@remark)";

//                    msqlCommand.Parameters.AddWithValue("@ImageId", ImageDetails.ImageId);
//                    msqlCommand.Parameters.AddWithValue("@files", ImageDetails.files);
//                    msqlCommand.Parameters.AddWithValue("@lastScannedDate", ImageDetails.lastScannedDate);
//                    msqlCommand.Parameters.AddWithValue("@lastUsedHost", ImageDetails.lastUsedHost);

//                    msqlCommand.ExecuteNonQuery();

//                    returnVal = 1;
//                }
//                catch (Exception er)
//                {
//                    returnVal = 0;
//                }
//                finally
//                {
//                    //always close the connection
//                    msqlConnection.Close();
//                }
//                return returnVal;
//            }


//            public static List<StorageImageInfo> GetAllImageList()
//            {
//                return QueryAllImageList();
//            }
//            /// <summary>
//            /// Queries all Image list.
//            /// </summary>
//            /// <returns></returns>
//            private static List<StorageImageInfo> QueryAllImageList()
//            {
//                List<StorageImageInfo> ImageList = new List<StorageImageInfo>();

//                MySql.Data.MySqlClient.MySqlConnection msqlConnection = OpenDbConnection();

//                try
//                {   //define the command reference
//                    MySql.Data.MySqlClient.MySqlCommand msqlCommand = new MySql.Data.MySqlClient.MySqlCommand();
//                    msqlCommand.Connection = msqlConnection;

//                    msqlCommand.CommandText = "Select * From Image ;";
//                    MySql.Data.MySqlClient.MySqlDataReader msqlReader = msqlCommand.ExecuteReader();

//                    while (msqlReader.Read())
//                    {
//                        StorageImageInfo Image = new StorageImageInfo();

//                        /*
//                        Image.ImageId = msqlReader.GetString("ImageId");
//                        Image.lastScannedDate = msqlReader.GetString("lastScannedDate");
//                        Image.lastUsedHost = msqlReader.GetString("lastUsedHost");
//                        Image.lastUsedHost = msqlReader.GetString("lastUsedHost");
//                        Image.files = msqlReader.GetString("files");               
//                        */

//                        ImageList.Add(Image);
//                    }

//                }
//                catch (Exception er)
//                {
//                }
//                finally
//                {
//                    //always close the connection
//                    msqlConnection.Close();
//                }

//                return ImageList;
//            }

//            #endregion



//        }
//    }

//}
