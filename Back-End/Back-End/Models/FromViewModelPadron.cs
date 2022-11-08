using Back_End.Models;
using System.Data;

public class FromViewModelPadron
{
    public string Id { get; set; }
    public DataTable datatable { get; set; }
    public FormCrearPadron padron { get; set; }
}