using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using System.Net;
using System.Net.Mail;

namespace 终了时MusicBox
{
    public partial class update : Form
    {
        public update()
        {
            InitializeComponent();
             //this.BackgroundImage = Image.FromFile(Form1.beijing);
            this.textBox3.Text = "2368962312@qq.com";//"1394371281@qq.com";
            this.textBox4.Text = "对 终了时MusicBox 的建议和设想";
            //this.label1.Text = "int main(int argc,char* argv[]){\n"+"}";
        }
        public void CreateTimeoutTestMessage(string server)
        {
            try
            {
                MailMessage Mail = new MailMessage();
                //  sc.Timeout = 9999;
                Mail.From = new MailAddress(this.textBox1.Text);
                Mail.To.Add(new MailAddress(this.textBox3.Text));
                Mail.Subject = textBox4.Text;
                Mail.IsBodyHtml = true;//.Trim().ToString()
                Mail.Body = this.richTextBox1.Text.Trim().ToString()+"\n\n     ——来自 终了时MusicBox ——".Trim().ToString();
                Mail.BodyEncoding = System.Text.Encoding.UTF8;
                Mail.Priority = MailPriority.High;
                if (!Add_attachment(Mail)) {
                    MessageBox.Show(" 附件添加失败\n ");
                }
                SmtpClient sc = new SmtpClient();
                sc.Credentials = new NetworkCredential(this.textBox1.Text, this.textBox2.Text);
                sc.Host = "smtp.163.com";
                sc.Port = 25;
                //   sc.UseDefaultCredentials = true;
                sc.EnableSsl = false;
                sc.Send(Mail);
                MessageBox.Show("发送成功。。。。。。   ");
            }
            catch (Exception ey)
            {
                MessageBox.Show(this, ey.Message, "提示对话框", MessageBoxButtons.OK, MessageBoxIcon.Information);
            }
        }
        bool Add_attachment(MailMessage Mail)
        {
            Attachment attach = new Attachment(textBox5.Text);
            Mail.Attachments.Add(attach);
            return true;
        }
        private void button2_Click(object sender, EventArgs e)
        {
            if (richTextBox1.Text.Trim().ToString() != "")
            {
                CreateTimeoutTestMessage("pop3.qq.com");
            }
            else
            {
                MessageBox.Show(this, "你发送内容为空，呵呵。。。再想想吧    ");
                return;
            }

        }
        private void button1_Click_1(object sender, EventArgs e)
        {
            OpenFileDialog of = new OpenFileDialog();
            of.Filter = "all files (*.*)|*.*";
            of.RestoreDirectory = true;
            if(of.ShowDialog() == DialogResult.OK){
                textBox5.Text = of.FileName;
            }
            else return;
        }
    }
}
