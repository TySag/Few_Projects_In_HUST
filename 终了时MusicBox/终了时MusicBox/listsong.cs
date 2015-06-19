using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace 终了时MusicBox
{
    public class listsong
    {
        public string listname= string.Empty;
        public songinf[] songname = new songinf[100];
        public int ns = 0;
        public bool xian = true;
        public string Glist
        {
            get { return this.listname; }
            set { this.listname = value; }
        }
    }
}
