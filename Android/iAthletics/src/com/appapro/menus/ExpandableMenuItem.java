package com.appapro.menus;

import android.graphics.Bitmap;
import android.graphics.drawable.BitmapDrawable;
import android.graphics.drawable.Drawable;
import android.view.LayoutInflater;
import android.view.View;
import android.widget.ImageView;
import android.widget.TextView;
import com.appapro.iathletics.R;

//ExpandableMenuItem
	//
	// This is an abstract class that is the base for all the
	// menu items. If controls the group and child menus
	//
public abstract class ExpandableMenuItem
{
	public abstract View getChildView(int childPosition, View convertView);
	public abstract View getGroupView(boolean isExpanded, View convertView);
	public abstract int getChildrenCount();
	public abstract Object getChild(int childPosition);
	
	// this method checks to see if a convert view we are given is tagged
	// with an object that matches the  class  specified 
	//
	protected final Boolean convertViewIsTagedWith(View convertView, Class<?> matchClass)
	{
		Object tag = convertView.getTag();
		
		return tag != null ? 
				(tag.getClass().getSimpleName().compareTo(matchClass.getSimpleName()) == 0) :
					false;
	}
	
	// this method is called when the group expands
	// most groups don't need to do anything special on expand so the default is a no-op
	// but derived classes can override of they need to do something special
	//
	public void onGroupExpand()	{}
	
	// handles child clicking. most sub-classes will implement 
	// real functionality here
	//
	public boolean onChildClick(int childPosition)
	{
		return false;
	}
	
	// uses a bitmap insetad of a Drawable
	//
	protected final View getItemIconGroupView(LayoutInflater inflator, String menuText, Bitmap img, View convertView)
	{
		Drawable drawable = new BitmapDrawable(img);
		return getItemIconGroupView(inflator, menuText, drawable, convertView);
	}
	
	// returns a standard child view
	//
	protected final View getItemIconChildView(LayoutInflater inflator, String text, Drawable icon, View convertView, int visability)
	{
		// A ViewHolder keeps references to children views to avoid unnecessary calls
		// to findViewById() on each row.
		//
     ItemIconViewHolder holder; 

     // When convertView is not null, we can reuse it directly, there is no need
     // to reinflate it. We only inflate a new View when the convertView supplied
     // by ListView is null.
     // We also need to double check that the converted view is of suitable type
     // to meet our needs.
     //
     if (convertView == null || 
     		!this.convertViewIsTagedWith(convertView, ItemIconViewHolder.class)) 
     {
         convertView = inflator.inflate(R.layout.list_item_icon_text, null);

         // Creates a ViewHolder and store references to the two children views
         // we want to bind data to.
         //
         holder = new ItemIconViewHolder();
         holder.text = (TextView) convertView.findViewById(R.id.text);
         holder.icon = (ImageView) convertView.findViewById(R.id.icon);

         // save the tag on the convert view
         //
         convertView.setTag(holder);
     } 
     else 
     {
         // Get the ViewHolder back to get fast access to the TextView
         // and the ImageView.
     	//
         holder = (ItemIconViewHolder) convertView.getTag();
     }

     // Bind the data efficiently with the holder.
     //
     holder.text.setText(text);
     holder.icon.setImageDrawable(icon);
	holder.icon.setVisibility(visability);
     
     return convertView;
	}
	
	// this class is used to store data in the Category Name
	// view of the expandable list
	//
	static class GroupViewHolder
	{
		TextView text;
	}

	static class ItemIconViewHolder
	{
		ImageView 	icon;
		TextView 	text;
	}
	
	protected final View getItemIconChildView(LayoutInflater inflator, String text, Bitmap icon, View convertView, int visibility)
	{
		Drawable drawable = new BitmapDrawable(icon);
		
		return getItemIconChildView(inflator, text, drawable, convertView, visibility);
	}
	
	// This method can inflate a standard view with text and an icon
	//
	protected final View getItemIconGroupView(LayoutInflater inflator, String text, Drawable icon, View convertView)
	{	
		// A ViewHolder keeps references to children views to avoid unnecessary calls
		// to findViewById() on each row.
		//
		ItemIconViewHolder holder; 

		// When convertView is not null, we can reuse it directly, there is no need
		// to reinflate it. We only inflate a new View when the convertView supplied
		// by ListView is null.
		// We also need to double check that the converted view is of suitable type
		// to meet our needs.
		//
		if (convertView == null || 
				!this.convertViewIsTagedWith(convertView, ItemIconViewHolder.class)) 
		{
			convertView = inflator.inflate(R.layout.main_menu_category, null);

			// Creates a ViewHolder and store references to the two children views
			// we want to bind data to.
			//
			holder = new ItemIconViewHolder();
			holder.text = (TextView) convertView.findViewById(R.id.text);
			holder.icon = (ImageView) convertView.findViewById(R.id.icon);

			// save the tag on the convert view
			//
			convertView.setTag(holder);
		} 
		else 
		{
			// Get the ViewHolder back to get fast access to the TextView
			// and the ImageView.
			//
			holder = (ItemIconViewHolder) convertView.getTag();
		}

		// Bind the data efficiently with the holder.
		//
		holder.text.setText(text);
		holder.icon.setImageDrawable(icon);

		return convertView;
	}
	
	public boolean isChildSelectable(int childPosition)
	{
		// we'll assume that the children are selectable and let
		// the implementor change it if they need to
		//
		return true;
	}
}
