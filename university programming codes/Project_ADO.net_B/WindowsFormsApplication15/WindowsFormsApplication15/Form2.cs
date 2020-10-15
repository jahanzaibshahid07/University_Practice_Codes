using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Text;
using System.Windows.Forms;
using System.Data.SqlClient;

namespace WindowsFormsApplication15
{
    public partial class Form2 : Form
    {
        public Form2()
        {
            InitializeComponent();
        }
        SqlConnection con = new SqlConnection("Data Source=HP\\SQLEXPRESS;Initial Catalog=inbasemgm;Integrated Security=True");
        private void button1_Click(object sender, EventArgs e)
        {
            con.Close();
            string s = "select * from products";
            SqlDataAdapter ad = new SqlDataAdapter(s,con);
            con.Open();
            DataTable td = new DataTable();
            ad.Fill(td);
            dataGridView1.DataSource = td;
        }

        private void button3_Click(object sender, EventArgs e)
        {
            DAL dal = new DAL();
            dal.insert(Convert.ToInt32(textBox1.Text), textBox2.Text, Convert.ToInt32(textBox3.Text));
            MessageBox.Show("Record have been inserted.....");
            textBox1.Clear();
            textBox2.Clear();
            textBox3.Clear();
            
        }

        private void button4_Click(object sender, EventArgs e)
        {
            DAL dal = new DAL();
            dal.delete(Convert.ToInt32(textBox4.Text));
            MessageBox.Show("Record have been Removed.....");
            textBox4.Clear();

        }

        private void button5_Click(object sender, EventArgs e)
        {
            DAL dal = new DAL();
            dal.update(Convert.ToInt32(textBox8.Text), Convert.ToInt32(textBox5.Text), textBox6.Text, Convert.ToInt32(textBox7.Text));
            MessageBox.Show("Record have been Updated.....");
            textBox8.Clear();
            textBox7.Clear();
            textBox5.Clear();
            textBox6.Clear();
        }

        private void button2_Click(object sender, EventArgs e)
        {
            this.Hide();
            Form1 f1 = new Form1();
            f1.Show();
        }
    }
}
