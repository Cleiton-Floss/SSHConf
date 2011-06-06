/* sshconf-entry-model.vala
 *
 * Copyright (C) 2011 Qball Cow <qball@gmpclient.org>
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 *
 * Author:
 * 	Qball Cow <qball@gmpclient.org>
 */
using Gtk;

namespace SSHConf
{
class EntryModel : GLib.Object, Gtk.TreeModel
{
    private GLib.List<Entry> entries;
    
    ~EntryModel()
    {
        entries = null;
        stdout.printf("~EntryModel\n");
    }

    public GLib.Type get_column_type(int index)
    {
        return typeof(SSHConf.Entry);
    }

    public Gtk.TreeModelFlags get_flags()
    {
        return Gtk.TreeModelFlags.LIST_ONLY;
    }
    
    public bool get_iter(out Gtk.TreeIter iter, Gtk.TreePath path)
    {
        int[] indices = path.get_indices ();
        unowned GLib.List<Entry> en = entries.nth(indices[0]);
        if(en != null)
        {
            iter = Gtk.TreeIter();
            // @todo fix stamp to update when list changes 
            iter.stamp = 1;
            iter.user_data = en;
            iter.user_data2 = indices[0].to_pointer();
            return true;
        }
        return false;
    }
    
    public int get_n_columns()
    {
        return 1;
    }
    
    public Gtk.TreePath get_path(Gtk.TreeIter iter)
    {
        int index = (int)(iter.user_data2);
        
        Gtk.TreePath path = new Gtk.TreePath.from_indices(index, -1);
        return path;
    }
    
    public void get_value(Gtk.TreeIter iter, int column,out Value val)
    {
        val = Value(this.get_column_type(column));
        Entry? en =  ((List<Entry>)iter.user_data).data;
        val.set_object(en);
    }

    public bool iter_children(out Gtk.TreeIter iter, Gtk.TreeIter? parent)
    {
        if(parent != null) return false;
        this.iter_first(out iter);
        return true;
    }
    public bool iter_has_child(Gtk.TreeIter iter)
    {
        return false;
    }
    public int iter_n_children(Gtk.TreeIter? iter)
    {
        if(iter != null) return 0;
        return (int)entries.length();
    }
    public bool iter_next(Gtk.TreeIter iter)
    {
        unowned List<Entry> entry = ((List<Entry>)iter.user_data);
        
        if(entry.next == null) return false;
        
        iter.stamp = 1;
        iter.user_data = entry.next;
        iter.user_data2 = ((int)(iter.user_data2)+1).to_pointer();
        return true;
    }
    public bool iter_nth_child(out Gtk.TreeIter iter, Gtk.TreeIter? parent, int n)
    {
        // no children
        if(parent != null) return false;
        unowned List<Entry>? en = entries.nth(n);
        if(en == null) return false;
        
        iter.stamp = 1;
        iter.user_data = (void*)en;
        iter.user_data2 = n.to_pointer();
        
        return true;
    }
    public bool iter_parent(out Gtk.TreeIter iter, Gtk.TreeIter child)
    {
        return false;
    }
    
    public void ref_node(Gtk.TreeIter iter)
    {
    }
    public void unref_node(Gtk.TreeIter iter)
    {
    }
    public bool iter_first(out Gtk.TreeIter iter)
    {
        if(entries.length() == 0) return false;
        iter.stamp = 1;
        iter.user_data = (void*)entries.first();
        iter.user_data2 = (1).to_pointer();
        return true;
    }
    
    public void add_entry (Entry entry)
    {
        entries.append(entry);
        Gtk.TreePath path = new Gtk.TreePath.from_indices(entries.length()-1,-1);
        Gtk.TreeIter iter;
        if(this.get_iter(out iter, path))
        {
            row_inserted(path, iter);
        }
    }
    public void remove_entry (Entry entry)
    {
        unowned List<Entry> en = entries.find(entry);
        if(en != null)
        {
            int index = entries.index(entry);
            Gtk.TreePath path = new Gtk.TreePath.from_indices(index, -1);
            Entry e = (owned)en.data;
            entries.delete_link(en);
            e = null;
            /* signal row deleted */
            row_deleted(path);
        }
    }
}
}