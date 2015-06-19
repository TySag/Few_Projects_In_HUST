using System;
using System.Collections.Generic;
using System.Text;

namespace PlaylistBox
{
    //自定义事件参数类
    public class ChatListEventArgs
    {
        private SongItem mouseOnSubItem;
        public SongItem MouseOnSubItem {
            get { return mouseOnSubItem; }
        }

        private SongItem selectSubItem;
        public SongItem SelectSubItem {
            get { return selectSubItem; }
        }

        public ChatListEventArgs(SongItem mouseonsubitem, SongItem selectsubitem) {
            this.mouseOnSubItem = mouseonsubitem;
            this.selectSubItem = selectsubitem;
        }
    }
}
