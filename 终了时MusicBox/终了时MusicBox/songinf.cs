using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace 终了时MusicBox
{
    public class songinf
    {
       public string sname= string.Empty;
       public string spath= string.Empty;
       public string Sname
       {
           get { return this.sname; }
           set { this.sname = value; }
       }
       public string Spath
       {
           get { return this.spath; }
           set { this.spath = value; }
       }
    }
}
