using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace FaceRecognitionLibrary
{
    public class ImageInfo 
    {
        public string imageId;
        public string dbpath;
        public int size;
        public byte[] bytes;
    }

    public enum UserType
    {
        admin,
        user
    }
   

    public class UserInfo
    {
        public string userId;
        public string userName;
        public string GoogleOpenId;

        public UserType type;

        List<ImageInfo> images;
    }

    public enum FaceRecognitionState
    {
        FaceDetection,
        FaceAlignment,
        FeatureExtraction,
        FeatureMatching
    }

    public class DbConnector
    {
        public string server;
        public string port;
        public string userId;
        public string password;
        public string connectionString;

        public UserInfo GetUserInfo(string id)
        {
            throw new NotImplementedException();
        }

        public ImageInfo GetImageInfo(string id)
        {
            throw new NotImplementedException();
        }
    }

    public class MatlabConnector
    {
        public string executionPath;
        public string connectionString;

        public byte[] DetectFace(byte[] input)
         
        {
            throw new NotImplementedException();
        }
        public byte[] AlignFace(byte[] input)
        {
            throw new NotImplementedException();
        }
        public byte[] ExtractFeature(byte[] input)
        {
            throw new NotImplementedException();
        }
        public UserInfo MatchFace(byte[] input)
        {
            throw new NotImplementedException();
        }
        public FaceRecognitionState GetAlgoState()
        {
            throw new NotImplementedException();
        }
    }

    public class FaceRecognitionController
    {
        public List<UserInfo> users;
        public MatlabConnector mConn;
        public DbConnector dbConn;
    }

}
