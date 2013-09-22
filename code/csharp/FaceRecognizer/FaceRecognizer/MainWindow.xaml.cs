using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Data;
using System.Windows.Documents;
using System.Windows.Input;
using System.Windows.Media;
using System.Windows.Media.Imaging;
using System.Windows.Navigation;
using System.Windows.Shapes;

namespace FaceRecognizer
{
    /// <summary>
    /// Interaction logic for MainWindow.xaml
    /// </summary>
    public partial class MainWindow : Window
    {
        public MainWindow()
        {
            InitializeComponent();
        }

        private void recognizeFace_Click(object sender, RoutedEventArgs e)
        {
            FaceRecognizer.RecognizeFace recognizeFaceobj = new FaceRecognizer.RecognizeFace();
            infodocP.Children.Clear();
            infodocP.Children.Add(recognizeFaceobj);
        }

        private void registerImages_Click(object sender, RoutedEventArgs e)
        {
            FaceRecognizer.RegisterImages registerImagesobj = new FaceRecognizer.RegisterImages();
            infodocP.Children.Clear();
            infodocP.Children.Add(registerImagesobj);
        }

        private void createAccount_Click(object sender, RoutedEventArgs e)
        {
            FaceRecognizer.CreateAccount createAccountobj = new FaceRecognizer.CreateAccount();
            infodocP.Children.Clear();
            infodocP.Children.Add(createAccountobj);
        }

        private void googleOpenID_Click(object sender, RoutedEventArgs e)
        {
            FaceRecognizer.GoogleOpenID googleOpenIDobj = new FaceRecognizer.GoogleOpenID();
            infodocP.Children.Clear();
            infodocP.Children.Add(googleOpenIDobj);
        }


    }
}
