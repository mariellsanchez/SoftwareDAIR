
using System.Web;

namespace Back_End.Models
{
    public class FormCrearPadron
    {
        public string Id { get; set; }
        public string AnioInicio { get; set; }
        public string AnioFin { get; set; }
        public string NombrePadron { get; set; }
        public HttpPostedFileBase ArchivoPadron { get; set; }
    }
}