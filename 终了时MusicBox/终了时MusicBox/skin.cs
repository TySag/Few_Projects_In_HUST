using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using System.IO;

namespace 终了时MusicBox
{
    public partial class skin : Form
    {
        public static string path1;
        public skin()
        {
            InitializeComponent();
            StreamReader read = new StreamReader("confi\\desk\\xuan.txt");
            path1 = read.ReadLine();
            this.BackgroundImage = Image.FromFile(path1);
            read.Close();
            read.Dispose();
            this.Location = new Point(400,300);
        }

        private void button1_Click(object sender, EventArgs e)
        {
            path1 = "confi\\desk\\1.jpg";
            this.BackgroundImage = Image.FromFile("confi\\desk\\1.jpg");
        }

        private void button2_Click(object sender, EventArgs e)
        {
            path1 = "confi\\desk\\2.jpg";
            this.BackgroundImage = Image.FromFile("confi\\desk\\2.jpg");
        }

        private void button3_Click(object sender, EventArgs e)
        {
            this.BackgroundImage = Image.FromFile("confi\\desk\\3.jpg");
            path1 = "confi\\desk\\3.jpg";
        }

        private void button4_Click(object sender, EventArgs e)
        {
            this.BackgroundImage = Image.FromFile("confi\\desk\\4.jpg");
            path1 = "confi\\desk\\4.jpg";
        }
        //musicName  = Path.GetFileNameWithoutExtension(包含扩展名的全路径);
        private void button5_Click(object sender, EventArgs e)
        {
            string bpic; 
            string tem1,tem2 ;
            OpenFileDialog bkpic = new OpenFileDialog();
            //bkpic.InitialDirectory = "c:\\";openfiledialog1.initialdirectory = backfilepath;
            bkpic.Filter = "图片文件(*.png;*.jpg;*.bmp)|*.png;*.jpg;*.bmp";
            bkpic.FilterIndex = 1;
            bkpic.RestoreDirectory = true;
            bkpic.Title = "皮肤换取";
            if (bkpic.ShowDialog() == DialogResult.OK)
            {
                bpic = bkpic.FileName;
                path1 = "confi\\desk\\" + bkpic.SafeFileName;
                tem1 = Path.GetFileNameWithoutExtension(path1);
                tem2= Path.GetExtension(path1);
loop  :         if (File.Exists(path1))
                {
                    tem1=tem1+"1";
                    path1 ="confi\\desk\\"+tem1 + tem2;
                    goto loop;
                }
                File.Copy(bpic, path1);
                this.BackgroundImage = Image.FromFile(path1);
            }
        }

        private void button6_Click(object sender, EventArgs e)
        {
            File.Delete("confi\\desk\\xuan.txt");
            StreamWriter white = File.CreateText("confi\\desk\\xuan.txt");
            white.WriteLine(path1);
            white.Close();
            white.Dispose();
            this.Close();
        }

        private void button7_Click(object sender, EventArgs e)
        {
            DialogResult dr = MessageBox.Show("是否退出设置？            ", "提示", MessageBoxButtons.YesNo, MessageBoxIcon.Question);
            if (dr == DialogResult.Yes)
            {
                this.Close();
            }
        }
    }
}
