using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows.Forms;

namespace 终了时MusicBox
{
    public partial class desklrc : Form
    {
        int x = 0, y = 0;
        bool move=false;
        public desklrc()
        {
            InitializeComponent();
            this.ForeColor = System.Drawing.SystemColors.Desktop;
            this.Opacity = 0.60;
            this.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen;
        }

        private void desklrc_MouseDown(object sender, MouseEventArgs e)
        {

            move = true;
            x = MousePosition.X;
            y = MousePosition.Y; 
        }

        private void desklrc_MouseUp(object sender, MouseEventArgs e)
        {
            move = false;
        }

        private void desklrc_MouseMove(object sender, MouseEventArgs e)
        {
            if (move)
            {
                this.Left += MousePosition.X - x;
                this.Top += MousePosition.Y - y;
                x = MousePosition.X;
                y = MousePosition.Y;
            }
        }

        private void timer1_Tick(object sender, EventArgs e)
        {
            if (Form1.gecix == true)
                if(Form1.hang>=1)
                this.label1.Text = Form1.gecinr[Form1.hang-1]+"\n"+Form1.gecinr[Form1.hang]+"\n"+Form1.gecinr[Form1.hang+1];
        }

        private void timer2_Tick(object sender, EventArgs e)
        {
            if (Form1.ji == 1)
                this.timer1.Enabled = true;
            else if(Form1.ji==0)
                this.timer1.Enabled = false;
        }
    }
}
