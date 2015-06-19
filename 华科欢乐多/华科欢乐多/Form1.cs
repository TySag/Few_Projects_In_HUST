using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using System.Threading;
using System.Configuration;

namespace 华科欢乐多
{
    
    public partial class Form1 : Form
    {
        bool movethebox = false;
        int xpos = 0, ypos = 0;
        public Form1()
        {
            InitializeComponent();
            //this.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen;
            this.Location = new Point(300,200);
        }
        private void Form1_KeyDown(object sender, KeyEventArgs e)
        {
            if (e.KeyCode == Keys.Escape)
            {
                DialogResult dr = MessageBox.Show("是否离开游戏？            ", "提示", MessageBoxButtons.YesNo, MessageBoxIcon.Question);
                if (dr == DialogResult.Yes)
                {
                    Application.Exit();
                }
            }
        }
        private void Form1_KeyPress(object sender, KeyPressEventArgs e)
        {
        }
        private void Form1_MouseMove(object sender, MouseEventArgs e)
        {
            if (movethebox)
            {
                this.Left += MousePosition.X - xpos;
                this.Top += MousePosition.Y - ypos;
                xpos = MousePosition.X;
                ypos = MousePosition.Y;
            } 
        }

        private void Form1_MouseUp(object sender, MouseEventArgs e)
        {
            movethebox = false;
        }

        private void Form1_MouseDown(object sender, MouseEventArgs e)
        {
            movethebox = true;
            xpos = MousePosition.X;
            ypos = MousePosition.Y;
        }

        private void button4_Click(object sender, EventArgs e)
        {
            DialogResult dr = MessageBox.Show("是否离开游戏？            ", "提示", MessageBoxButtons.YesNo, MessageBoxIcon.Question);
            if (dr == DialogResult.Yes)
            {
                Application.Exit();
            }
        }

        private void button1_Click(object sender, EventArgs e)//注册
        {
            Thread reg = new Thread(new ThreadStart(this.zhuce)); reg.IsBackground = true;
            reg.SetApartmentState(ApartmentState.STA);
            reg.Start();
        }
        private void zhuce() {
            Form2 ef = new Form2();
            ef.ShowDialog();
        }
        private void button2_Click(object sender, EventArgs e)//登入
        {
            //shujukuchazhao
            //meiyouzidongtiaodaozhuce,jinruzhucx
            Beginwithgame();
        }
        private void Beginwithgame(){

        }
        private void button3_Click(object sender, EventArgs e)
        {
            this.textBox1.Text = "";
            this.textBox2.Text = "";
        }

    }
}
