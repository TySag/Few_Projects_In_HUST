using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Drawing;
using System.Data;
using System.Linq;
using System.Text;
using System.Windows.Forms;

namespace MediaControlLibrary
{
    public partial class MediaAddButton : Label
    {
        public MediaAddButton()
        {
            InitializeComponent();
            this.Height = 29;
            this.AutoSize = false;
            this.BackColor = Color.Transparent;
            this.Font = new Font("宋体", 10, FontStyle.Underline);
            this.ForeColor = Color.Black;
            base.TextAlign = ContentAlignment.MiddleRight;
            base.ImageAlign = ContentAlignment.MiddleLeft;  
        }

        private AddType _type;
        [DefaultValue(typeof(AddType),"AddFiles")]
        [Browsable(true),Category("外观"),Description("按钮类型")]
        public AddType Type
        {
            get { return _type; }
            set
            {
                if (_type == value)
                    return;
                _type = value;
                this.Invalidate();
            }
        }

        protected override void OnPaint(PaintEventArgs e)
        {
            if (_type == AddType.AddFiles)
            {
                this.Width = 105;
                this.Image = global::MediaControlLibrary.Properties.Resources.addfiles;                         
                this.Text = "添加本地歌曲";
            }
            else
            {
                this.Width = 140;
                this.Image = global::MediaControlLibrary.Properties.Resources.addfolder;
                this.Text = "添加本地歌曲文件夹";
            }
            base.OnPaint(e);
        }
    }

    public enum AddType
    {
        AddFiles,
        AddFolder
    }
}
