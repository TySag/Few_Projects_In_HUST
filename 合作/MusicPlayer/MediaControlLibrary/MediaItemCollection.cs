using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Collections;

namespace MediaControlLibrary
{
    public class MediaItemCollection:IList,ICollection,IEnumerable
    {
        private MediaItem[] items;
        private MediaItem[] tmp_items;
        private MediaList ownerList;
        private int _count;
        /// <summary>
        /// 列表项所在的媒体项总和
        /// </summary>
        public int Count
        {
            get { return _count; }
        }

        public MediaItemCollection(MediaList list)
        {
            this.ownerList = list;
        }

        private void EnsureSpace(int elements)
        {
            if (items == null)
            {
                items = new MediaItem[Math.Max(4, elements)];
            }
            else if (elements + this._count > items.Length)
            {
                MediaItem[] arr_temp = new MediaItem[Math.Max(elements + this._count, items.Length * 2)];
                items.CopyTo(arr_temp, 0);
                items = arr_temp;
            }
        }

        public void Sort()
        {
            Array.Sort<MediaItem>(items, 0, this._count, null);
            if (this.ownerList != null)
                if (this.ownerList.OwnerContainer != null)
                    this.ownerList.OwnerContainer.Invalidate();
        }

        public void Add(MediaItem item)
        {
            this.EnsureSpace(1);
            if (item == null)
                throw new ArgumentNullException("item can not be null");
            if (-1 == IndexOf(item))
            {
                item.OwnerList = this.ownerList;
                items[this._count++] = item;
                if (this.ownerList != null)
                    if (this.ownerList.OwnerContainer != null)
                        this.ownerList.OwnerContainer.Invalidate();
            }
        }

        public void AddRange(MediaItem[] values)
        {
            if (values == null)
                throw new ArgumentNullException("values can not be null");
            this.EnsureSpace(values.Length);
            try
            {
                foreach (MediaItem item in values)
                {
                    if (item == null)
                        throw new ArgumentNullException("item can not be null");
                    if (-1 == IndexOf(item))
                    {
                        item.OwnerList = this.ownerList;
                        items[this._count++] = item;
                    }
                }
            }
            finally
            {
                if (this.ownerList != null)
                    if (this.ownerList.OwnerContainer != null)
                        this.ownerList.OwnerContainer.Invalidate();
            }
        }

        public void Clear()
        {
            this._count = 0;
            items = null;
            if (this.ownerList != null)
                if (this.ownerList.OwnerContainer != null)
                    this.ownerList.OwnerContainer.Invalidate();
        }

        public bool Contains(MediaItem item)
        {
            return -1 != IndexOf(item);
        }

        public void Insert(int index, MediaItem item)
        {
            if (index < 0 || index > this._count)
                throw new ArgumentOutOfRangeException("The index has been out of the range");
            if (item == null)
                throw new ArgumentNullException("The item can not be null");
            this.EnsureSpace(1);
            for (int i = this._count; i > index; i--)
            {
                items[i] = items[i - 1];
            }
            item.OwnerList = this.ownerList;
            items[index] = item;
            this._count++;
            if (this.ownerList != null)
                if (this.ownerList.OwnerContainer != null)
                    this.ownerList.OwnerContainer.Invalidate();
        }

        public void RemoveAt(int index)
        {
            if (index < 0 || index > this._count)
                throw new ArgumentOutOfRangeException("The index has been out of the range");
            this._count--;
            for (int i = index, len = this._count; i < len; i++)
                items[i] = items[i + 1];
            if (this.ownerList != null)
                if (this.ownerList.OwnerContainer != null)
                    this.ownerList.OwnerContainer.Invalidate();
        }

        public void Remove(MediaItem item)
        {
            if (item == null)
                throw new ArgumentNullException("The item can not be null");
            RemoveAt(IndexOf(item));
        }

        public MediaItem this[int index]
        {
            get
            {
                if (index < 0 || index > this._count)
                    throw new ArgumentOutOfRangeException("The index has been out of the range");
                return items[index];
            }
            set
            {
                if (index < 0 || index > this._count)
                    throw new ArgumentOutOfRangeException("The index has been out of the range");
                items[index] = value;
                if (this.ownerList != null)
                    if (this.ownerList.OwnerContainer != null)
                        this.ownerList.OwnerContainer.Invalidate(items[index].ClipBounds);
            }
        }

        public void CopyTo(Array array, int index)
        {
            if (array == null)
                throw new ArgumentNullException("The array can not be null");
            items.CopyTo(array, index);
        }

        public int IndexOf(MediaItem item)
        {
            return Array.IndexOf<MediaItem>(items,item);
        }

        public void FindItemByKey(string key)
        {
            if (items != null && ownerList != null)
            {
                if (tmp_items==null)
                {
                    tmp_items = new MediaItem[_count];
                    Array.Copy(items, tmp_items, _count);
                }
                var query = from r in tmp_items
                            where r.FirstContent.IndexOf(key) != -1
                            select r;
                items = null;
                items = query.ToList<MediaItem>().ToArray();
                _count = items.Length;
            }
        }

        int IList.Add(object value)
        {
            if (!(value is MediaItem))
                throw new ArgumentException("The value can not be convert to MediaItem");
            Add((MediaItem)value);
            return this.IndexOf((MediaItem)value);
        }

        void IList.Clear()
        {
            this.Clear();
        }

        bool IList.Contains(object value)
        {
            if (!(value is MediaItem))
                throw new ArgumentException("The value can not be convert to MediaItem");
            return this.Contains((MediaItem)value);
        }

        int IList.IndexOf(object value)
        {
            if (!(value is MediaItem))
                throw new ArgumentException("The value can not be convert to MediaItem");
            return IndexOf((MediaItem)value);
        }

        void IList.Insert(int index, object value)
        {
            if (!(value is MediaItem))
                throw new ArgumentException("The value can not be convert to MediaItem");
            this.Insert(index, (MediaItem)value);
        }

        bool IList.IsFixedSize
        {
            get { return false; }
        }

        bool IList.IsReadOnly
        {
            get { return false; }
        }

        void IList.Remove(object value)
        {
            if (!(value is MediaItem))
                throw new ArgumentException("The value can not be convert to MediaItem");
            this.Remove((MediaItem)value);
        }

        void IList.RemoveAt(int index)
        {
            this.RemoveAt(index);
        }

        object IList.this[int index]
        {
            get
            {
                return this[index];
            }
            set
            {
                if (!(value is MediaItem))
                    throw new ArgumentException("The value can not be convert to MediaItem");
                this[index] = (MediaItem)value;
                if (this.ownerList != null)
                    if (this.ownerList.OwnerContainer != null)
                        this.ownerList.OwnerContainer.Invalidate(this[index].ClipBounds);
            }
        }

        void ICollection.CopyTo(Array array, int index)
        {
            this.CopyTo(array, index);
        }

        int ICollection.Count
        {
            get { return this._count; }
        }

        bool ICollection.IsSynchronized
        {
            get { return true; }
        }

        object ICollection.SyncRoot
        {
            get { return this; }
        }

        IEnumerator IEnumerable.GetEnumerator()
        {
            if (items == null)
                throw new ArgumentNullException("There is no MediaItem in items");
            for (int i = 0, len = this._count; i < len; i++)
                yield return items[i];
        }
    }
}
