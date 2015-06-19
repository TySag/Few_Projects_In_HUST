namespace Car
{
    partial class Login
    {
        /// <summary>
        /// 必需的设计器变量。
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        /// 清理所有正在使用的资源。
        /// </summary>
        /// <param name="disposing">如果应释放托管资源，为 true；否则为 false。</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Windows 窗体设计器生成的代码

        /// <summary>
        /// 设计器支持所需的方法 - 不要
        /// 使用代码编辑器修改此方法的内容。
        /// </summary>
        private void InitializeComponent()
        {
            System.ComponentModel.ComponentResourceManager resources = new System.ComponentModel.ComponentResourceManager(typeof(Login));
            this.Sign = new System.Windows.Forms.Button();
            this.Reg = new System.Windows.Forms.Button();
            this.UserLabel = new System.Windows.Forms.Label();
            this.PassWordLabel = new System.Windows.Forms.Label();
            this.UserBox = new System.Windows.Forms.TextBox();
            this.PassBox = new System.Windows.Forms.TextBox();
            this.Cancel = new System.Windows.Forms.Button();
            this.MailLabel = new System.Windows.Forms.Label();
            this.MailBox = new System.Windows.Forms.TextBox();
            this.ID_LEVEL = new System.Windows.Forms.ComboBox();
            this.ID_LABEL = new System.Windows.Forms.Label();
            this.SuspendLayout();
            // 
            // Sign
            // 
            this.Sign.Location = new System.Drawing.Point(86, 216);
            this.Sign.Name = "Sign";
            this.Sign.Size = new System.Drawing.Size(78, 34);
            this.Sign.TabIndex = 0;
            this.Sign.Text = "确定";
            this.Sign.UseVisualStyleBackColor = true;
            this.Sign.Click += new System.EventHandler(this.Sign_Click);
            // 
            // Reg
            // 
            this.Reg.Location = new System.Drawing.Point(357, 216);
            this.Reg.Name = "Reg";
            this.Reg.Size = new System.Drawing.Size(79, 31);
            this.Reg.TabIndex = 1;
            this.Reg.Text = "注册";
            this.Reg.UseVisualStyleBackColor = true;
            this.Reg.Click += new System.EventHandler(this.Reg_Click);
            // 
            // UserLabel
            // 
            this.UserLabel.AutoSize = true;
            this.UserLabel.Location = new System.Drawing.Point(149, 34);
            this.UserLabel.Name = "UserLabel";
            this.UserLabel.Size = new System.Drawing.Size(41, 12);
            this.UserLabel.TabIndex = 2;
            this.UserLabel.Text = "用户名";
            // 
            // PassWordLabel
            // 
            this.PassWordLabel.AutoSize = true;
            this.PassWordLabel.Location = new System.Drawing.Point(153, 79);
            this.PassWordLabel.Name = "PassWordLabel";
            this.PassWordLabel.Size = new System.Drawing.Size(35, 12);
            this.PassWordLabel.TabIndex = 3;
            this.PassWordLabel.Text = "密 码";
            // 
            // UserBox
            // 
            this.UserBox.Location = new System.Drawing.Point(244, 31);
            this.UserBox.Name = "UserBox";
            this.UserBox.Size = new System.Drawing.Size(206, 21);
            this.UserBox.TabIndex = 4;
            // 
            // PassBox
            // 
            this.PassBox.Location = new System.Drawing.Point(244, 76);
            this.PassBox.Name = "PassBox";
            this.PassBox.PasswordChar = '*';
            this.PassBox.Size = new System.Drawing.Size(206, 21);
            this.PassBox.TabIndex = 5;
            // 
            // Cancel
            // 
            this.Cancel.Location = new System.Drawing.Point(232, 214);
            this.Cancel.Name = "Cancel";
            this.Cancel.Size = new System.Drawing.Size(77, 33);
            this.Cancel.TabIndex = 6;
            this.Cancel.Text = "取消";
            this.Cancel.UseVisualStyleBackColor = true;
            this.Cancel.Click += new System.EventHandler(this.Cancel_Click);
            // 
            // MailLabel
            // 
            this.MailLabel.AutoSize = true;
            this.MailLabel.Location = new System.Drawing.Point(153, 116);
            this.MailLabel.Name = "MailLabel";
            this.MailLabel.Size = new System.Drawing.Size(35, 12);
            this.MailLabel.TabIndex = 7;
            this.MailLabel.Text = "邮 箱";
            // 
            // MailBox
            // 
            this.MailBox.Location = new System.Drawing.Point(244, 116);
            this.MailBox.Name = "MailBox";
            this.MailBox.Size = new System.Drawing.Size(206, 21);
            this.MailBox.TabIndex = 8;
            this.MailBox.Text = "注册填写";
            // 
            // ID_LEVEL
            // 
            this.ID_LEVEL.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList;
            this.ID_LEVEL.FormattingEnabled = true;
            this.ID_LEVEL.Items.AddRange(new object[] {
            "Users",
            "Staffs"});
            this.ID_LEVEL.Location = new System.Drawing.Point(244, 155);
            this.ID_LEVEL.Name = "ID_LEVEL";
            this.ID_LEVEL.Size = new System.Drawing.Size(121, 20);
            this.ID_LEVEL.TabIndex = 9;
            // 
            // ID_LABEL
            // 
            this.ID_LABEL.AutoSize = true;
            this.ID_LABEL.Location = new System.Drawing.Point(149, 163);
            this.ID_LABEL.Name = "ID_LABEL";
            this.ID_LABEL.Size = new System.Drawing.Size(53, 12);
            this.ID_LABEL.TabIndex = 10;
            this.ID_LABEL.Text = "登陆身份";
            // 
            // Login
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 12F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.BackgroundImage = ((System.Drawing.Image)(resources.GetObject("$this.BackgroundImage")));
            this.BackgroundImageLayout = System.Windows.Forms.ImageLayout.Zoom;
            this.ClientSize = new System.Drawing.Size(529, 308);
            this.Controls.Add(this.ID_LABEL);
            this.Controls.Add(this.ID_LEVEL);
            this.Controls.Add(this.MailBox);
            this.Controls.Add(this.MailLabel);
            this.Controls.Add(this.Cancel);
            this.Controls.Add(this.PassBox);
            this.Controls.Add(this.UserBox);
            this.Controls.Add(this.PassWordLabel);
            this.Controls.Add(this.UserLabel);
            this.Controls.Add(this.Reg);
            this.Controls.Add(this.Sign);
            this.FormBorderStyle = System.Windows.Forms.FormBorderStyle.None;
            this.Name = "Login";
            this.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen;
            this.Text = "Sign In";
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.Button Sign;
        private System.Windows.Forms.Button Reg;
        private System.Windows.Forms.Label UserLabel;
        private System.Windows.Forms.Label PassWordLabel;
        private System.Windows.Forms.TextBox UserBox;
        private System.Windows.Forms.TextBox PassBox;
        private System.Windows.Forms.Button Cancel;
        private System.Windows.Forms.Label MailLabel;
        private System.Windows.Forms.TextBox MailBox;
        private System.Windows.Forms.ComboBox ID_LEVEL;
        private System.Windows.Forms.Label ID_LABEL;
    }
}

