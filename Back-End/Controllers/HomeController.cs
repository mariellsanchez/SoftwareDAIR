using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Data.SqlClient;
using System.Data;
using System.Configuration;
using System.IO;
using System.Text;
using System.Web.UI.WebControls;
using System.Reflection;
using Back_End.Models;
//using static System.Net.WebRequestMethods;

namespace Back_End.Controllers
{
    public class HomeController : Controller
    {
        // GET: Home
        [Route("Home")]
        [Route("Home/Index")]
        public ActionResult Index()
        {
            return View();
        }
        [Route("Home/SesionesAIR")]
        public ActionResult SesionesAIR()
        {
            SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString);
            con.Open();
            SqlCommand cmd = new SqlCommand("EXEC GetSesionesAIR", con);
            SqlDataAdapter da = new SqlDataAdapter(cmd);
            DataTable dt = new DataTable();
            con.Close();
            da.Fill(dt);
            return View(dt);
        }
        
        [Route("Home/SesionesDAIR")]
        public ActionResult SesionesDAIR()
        {
            SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString);
            con.Open();
            SqlCommand cmd = new SqlCommand("EXEC GetSesionesDAIR", con);
            SqlDataAdapter da = new SqlDataAdapter(cmd);
            DataTable dt = new DataTable();
            con.Close();
            da.Fill(dt);
            return View(dt);

        }
        
        [Route("Home/SesionAIR")]
        public ActionResult SesionAIR(string id)
        {
            SqlConnection conection = new SqlConnection(ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString);
            conection.Open();
            SqlCommand cmd = new SqlCommand("EXEC ReadSesionAIR " + id, conection);
            SqlDataAdapter data = new SqlDataAdapter(cmd);
            DataTable datatable = new DataTable();
            data.Fill(datatable);
            ViewBag.Nombre = datatable.Rows[0]["Nombre"];
            ViewBag.Fecha = datatable.Rows[0]["Fecha"];
            ViewBag.HoraInicio = datatable.Rows[0]["HoraInicio"];
            ViewBag.HoraFinal = datatable.Rows[0]["HoraFin"];
            ViewBag.SesionAIRId = id;
            SqlCommand cmd2 = new SqlCommand("EXEC GetPropuestasAIR " + id, conection);
            SqlDataAdapter data2 = new SqlDataAdapter(cmd2);
            DataTable datatable2 = new DataTable();
            data2.Fill(datatable2);
            conection.Close();
            return View(datatable2);
        }

        [Route("Home/SesionDAIR")]
        public ActionResult SesionDAIR(string id)
        {
            SqlConnection conection = new SqlConnection(ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString);
            conection.Open();
            SqlCommand cmd = new SqlCommand("EXEC ReadSesionDAIR " + id, conection);
            SqlDataAdapter data = new SqlDataAdapter(cmd);
            DataTable datatable = new DataTable();
            data.Fill(datatable);
            ViewBag.Nombre = datatable.Rows[0]["Nombre"];
            ViewBag.Fecha = datatable.Rows[0]["Fecha"];
            ViewBag.HoraInicio = datatable.Rows[0]["HoraInicio"];
            ViewBag.HoraFinal = datatable.Rows[0]["HoraFin"];
            ViewBag.SesionDAIRId = id;
            SqlCommand cmd2 = new SqlCommand("EXEC GetPropuestasDAIR " + id, conection);
            SqlDataAdapter data2 = new SqlDataAdapter(cmd2);
            DataTable datatable2 = new DataTable();
            data2.Fill(datatable2);
            conection.Close();
            return View(datatable2);
        }

        [Route("Home/CrearSesionAIR")]
        public ActionResult CrearSesionAIR()
        {
            SqlConnection conection = new SqlConnection(ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString);
            conection.Open();
            SqlCommand cmd = new SqlCommand("SELECT * FROM dbo.Periodo;", conection);
            SqlDataAdapter data = new SqlDataAdapter(cmd);
            DataTable datatable = new DataTable();
            conection.Close();
            data.Fill(datatable);
            List<SelectListItem> items = new List<SelectListItem>();
            foreach (DataRow row in datatable.Rows) {
                items.Add(new SelectListItem { Text = row["AnioInicio"].ToString()+" - "+ row["AnioFin"].ToString(), Value = row["Id"].ToString() });
            }
            ViewBag.Periodo = items;
            return View();
        }

        [HttpPost]
        public ActionResult GuardarNuevaSesionAIR(FormCrearSesionAIR model){
            if (ModelState.IsValid)
            {
                string path = "";
                try
                {
                    if (model.ArchivoPadron.ContentLength > 0)
                    {
                        string _FileName = Path.GetFileName(model.ArchivoPadron.FileName);
                        string _path = Path.Combine(Server.MapPath("~/UploadedFiles"), _FileName);
                        model.ArchivoPadron.SaveAs(_path);
                        path = _path;
                    }
                    ViewBag.Message = "File Uploaded Successfully!!";
                    //return View();
                }
                catch
                {
                    ViewBag.Message = "File upload failed!!";
                    //return View();
                }

                SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString);
                con.Open();
                SqlCommand cmd = new SqlCommand("EXEC CreateSesionAIR "
                    + model.Periodo + ", '"
                    + model.Nombre + "', '"
                    + model.Fecha + "', '"
                    + model.TiempoInicial + "', '"
                    + model.TiempoFinal + "', '"
                    + model.Descripcion + "', '"
                    + model.Link + "'", con);
                var temp = cmd.ExecuteScalar();
                SqlCommand cmd2 = new SqlCommand("EXEC NuevoRegistroAIR " + Convert.ToString(temp) +
                                                ", '" + path + "', '" +
                                                model.NombrePadron + "'");
                cmd2.Connection = con;
                cmd2.ExecuteNonQuery();
                SqlDataAdapter da = new SqlDataAdapter(cmd);
                //DataTable dt = new DataTable();
                con.Close();
                //da.Fill(dt);
            }
            return RedirectToAction("SesionesAIR");
        }



        [Route("Home/CrearSesionDAIR")]
        public ActionResult CrearSesionDAIR()
        {
            SqlConnection conection = new SqlConnection(ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString);
            conection.Open();
            SqlCommand cmd = new SqlCommand("SELECT * FROM dbo.Periodo;", conection);
            SqlDataAdapter data = new SqlDataAdapter(cmd);
            DataTable datatable = new DataTable();
            conection.Close();
            data.Fill(datatable);
            List<SelectListItem> items = new List<SelectListItem>();
            foreach (DataRow row in datatable.Rows)
            {
                items.Add(new SelectListItem { Text = row["AnioInicio"].ToString() + " - " + row["AnioFin"].ToString(), Value = row["Id"].ToString() });
            }
            ViewBag.Periodo = items;
            return View();
        }

        [HttpPost]
        public ActionResult GuardarNuevaSesionDAIR(FormCrearSesionDAIR model)
        {
            if (ModelState.IsValid)
            {
                SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString);
                con.Open();
                SqlCommand cmd = new SqlCommand("EXEC CreateSesionDAIR "
                    + model.Periodo + ", '"
                    + model.Nombre + "', '"
                    + model.Fecha + "', '"
                    + model.TiempoInicial + "', '"
                    + model.TiempoFinal + "', '"
                    + model.Descripcion + "', '"
                    + model.PathArchivo + "'", con);
                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                con.Close();
                da.Fill(dt);
            }
            return RedirectToAction("SesionesDAIR");
        }


        [Route("Home/Propuesta")]
        // https://stackoverflow.com/questions/11100981/asp-net-mvc-open-pdf-file-in-new-window
        public ActionResult Propuesta(string path)
        {
            return File(path, "application/pdf");
        }

        [Route("Home/EditarSesionAIR")]
        // https://stackoverflow.com/questions/11100981/asp-net-mvc-open-pdf-file-in-new-window
        public ActionResult EditarSesionAIR(string id)
        {
            SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString);
            con.Open();
            SqlCommand cmd = new SqlCommand("EXEC ReadSesionAIR " + id, con);
            SqlDataAdapter da = new SqlDataAdapter(cmd);
            DataTable dt = new DataTable();
            con.Close();
            da.Fill(dt);
            ViewBag.NombreSesionAIR = dt.Rows[0]["Nombre"];
            ViewBag.LinkAIR = dt.Rows[0]["Link"];
            ViewBag.Id = dt.Rows[0]["Id"].ToString();
            return View();
            //return File(path, "application/pdf");
        }

        [HttpPost]
        public ActionResult EnviarEdicionSesionAIR(FormEditarDetallesSesionAIR model)
        {
            if (ModelState.IsValid)
            {
                System.Console.WriteLine("Se tiene la infomacion");
                string path = "";
                try
                {
                    if (model.ArchivoPadron.ContentLength > 0)
                    {
                        string _FileName = Path.GetFileName(model.ArchivoPadron.FileName);
                        string _path = Path.Combine(Server.MapPath("~/UploadedFiles"), _FileName);
                        model.ArchivoPadron.SaveAs(_path);
                        path = _path;
                    }
                    ViewBag.Message = "File Uploaded Successfully!!";
                    //return View();
                }
                catch
                {
                    ViewBag.Message = "File upload failed!!";
                    //return View();
                }
                SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString);
                con.Open();
                SqlCommand cmd = new SqlCommand("EXEC UpdateSesionAIR " + model.Id + 
                                                ", '" + model.Nombre + "', '" + 
                                                model.Fecha + "', '" + 
                                                model.TiempoInicial + "', '" + 
                                                model.TiempoFinal + "', '" + 
                                                model.Link + "'", con);
                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                SqlCommand cmd2 = new SqlCommand("EXEC NuevoRegistroAIR " + model.Id +
                                                ", '" + path + "', '" +
                                                model.NombrePadron+"'");
                cmd2.Connection = con;
                cmd2.ExecuteNonQuery();
                //SqlDataAdapter da2 = new SqlDataAdapter(cmd2);
                //DataTable dt2 = new DataTable();
                con.Close();
                da.Fill(dt);
                //da2.Fill(dt2);
            }
            return RedirectToAction("SesionesAIR");
        }

        [Route("Home/EditarSesionDAIR")]
        // https://stackoverflow.com/questions/11100981/asp-net-mvc-open-pdf-file-in-new-window
        public ActionResult EditarSesionDAIR(string id)
        {
            SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString);
            con.Open();
            SqlCommand cmd = new SqlCommand("EXEC ReadSesionDAIR " + id, con);
            SqlDataAdapter da = new SqlDataAdapter(cmd);
            DataTable dt = new DataTable();
            con.Close();
            da.Fill(dt);
            ViewBag.NombreSesionDAIR = dt.Rows[0]["Nombre"];
            ViewBag.LinkDAIR = dt.Rows[0]["Link"];
            ViewBag.Id = dt.Rows[0]["Id"].ToString();
            return View();
            //return File(path, "application/pdf");
        }

        [HttpPost]
        public ActionResult EnviarEdicionSesionDAIR(FormEditarDetallesSesionAIR model)
        {
            if (ModelState.IsValid)
            {
                System.Console.WriteLine("Se tiene la infomacion");
                SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString);
                con.Open();
                SqlCommand cmd = new SqlCommand("EXEC UpdateSesionDAIR " + model.Id + ", '" + model.Nombre + "', '" + model.Fecha + "', '" + model.TiempoInicial + "', '" + model.TiempoFinal + "', '" + model.Link + "'", con);
                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                con.Close();
                da.Fill(dt);
            }
            return RedirectToAction("SesionesDAIR");
        }

        public ActionResult BorrarSesionAIR(string id)
        {
            SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString);
            con.Open();
            SqlCommand cmd = new SqlCommand("EXEC DeleteSesionAIR " + id, con);
            SqlDataAdapter da = new SqlDataAdapter(cmd);
            DataTable dt = new DataTable();
            con.Close();
            da.Fill(dt);
            return RedirectToAction("SesionesAIR");
        }

        public ActionResult BorrarSesionDAIR(string id)
        {
            SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString);
            con.Open();
            SqlCommand cmd = new SqlCommand("EXEC DeleteSesionDAIR " + id, con);
            SqlDataAdapter da = new SqlDataAdapter(cmd);
            DataTable dt = new DataTable();
            con.Close();
            da.Fill(dt);
            return RedirectToAction("SesionesDAIR");
        }

        public ActionResult PropuestaAIR(string id)
        {
            SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString);
            con.Open();
            SqlCommand cmd = new SqlCommand("EXEC ReadSesionAIR " + id, con);
            SqlDataAdapter da = new SqlDataAdapter(cmd);
            DataTable dt = new DataTable();
            con.Close();
            da.Fill(dt);
            ViewBag.NombreSesionAIR = dt.Rows[0]["Nombre"];
            ViewBag.Id = dt.Rows[0]["Id"].ToString();
            return View();
        }

        
        public ActionResult BorrarPropuestaAIR(String id)
        {
            SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString);
            con.Open();
            SqlCommand cmd = new SqlCommand("EXEC DeletePropuestaAIR " + id, con);
            SqlDataAdapter da = new SqlDataAdapter(cmd);
            DataTable dt = new DataTable();
            con.Close();
            da.Fill(dt);
            return RedirectToAction("SesionesAIR");
        }

        [Route("Home/EditarPropuestaAIR")]
        public ActionResult EditarPropuestaAIR(String id)
        {
            SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString);
            con.Open();
            SqlCommand cmd = new SqlCommand("EXEC ReadPropuestaAIR " + id, con);
            SqlDataAdapter da = new SqlDataAdapter(cmd);
            DataTable dt = new DataTable();
            con.Close();
            da.Fill(dt);
            ViewBag.NombrePropuestaAIR = dt.Rows[0]["Nombre1"];
            ViewBag.ID = id;
            return View();
        }

        //EDITAR PROPUESTA DAIR
        [Route("Home/EditarPropuestaDAIR")]
        public ActionResult EditarPropuestaDAIR(String id)
        {
            SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString);
            con.Open();
            SqlCommand cmd = new SqlCommand("EXEC ReadPropuestaDAIR " + id, con);
            SqlDataAdapter da = new SqlDataAdapter(cmd);
            DataTable dt = new DataTable();
            con.Close();
            da.Fill(dt);
            ViewBag.NombrePropuestaDAIR = dt.Rows[0]["Nombre"];
            ViewBag.ID = id;
            ViewBag.Link = dt.Rows[0]["Link"];
            return View();
        }

        [HttpPost]
        public ActionResult EnviarEdicionPropuestaAIR(FormEditarPropuestaAIR model)
        {
            if (!ModelState.IsValid)
            {
                System.Console.WriteLine("Se tiene la infomacion");
                SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString);
                con.Open();

                SqlCommand cmd = new SqlCommand("EXEC UpdatePropuestaAIR "
                    + model.Id + ", '"
                    + model.EtapaId + "', '"
                    + model.Aprovado + "', '"
                    + model.Nombre + "', '"
                    + model.Link + "', '"
                    + model.NumeroPropuesta + "', '"
                    + model.VotosFavor + "', '"
                    + model.VotosContra + "', '"
                    + model.VotosBlanco + "'", con);

                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                con.Close();
                da.Fill(dt);
            }
            return RedirectToAction("SesionesAIR");
        }


        //BORRAR PROPUESTA DAIR
        public ActionResult BorrarPropuestaDAIR(String id)
        {
            SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString);
            con.Open();
            SqlCommand cmd = new SqlCommand("EXEC DeletePropuestaDAIR " + id, con);
            SqlDataAdapter da = new SqlDataAdapter(cmd);
            DataTable dt = new DataTable();
            con.Close();
            da.Fill(dt);
            return RedirectToAction("SesionesDAIR");
        }

        //CREAR PROPUESTA AIR
        [Route("Home/CrearPropuestaDAIR")]
        public ActionResult CrearPropuestaDAIR(String SesionDAIRId)
        {
            ViewBag.SesionDAIRId = SesionDAIRId.ToString();
            List<SelectListItem> items_aprovado = new List<SelectListItem>();
            items_aprovado.Add(new SelectListItem { Text = "Sí", Value = "1" });
            items_aprovado.Add(new SelectListItem { Text = "No", Value = "0" });
            ViewBag.Aprovado = items_aprovado;
            return View();
        }

        [HttpPost]
        public ActionResult GuardarNuevaPropuestaDAIR(FormCrearPropuestaDAIR model)
        {
            if (ModelState.IsValid)
            {
                SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString);
                con.Open();
                SqlCommand cmd = new SqlCommand("EXEC CreatePropuestaDAIR "
                    + model.Id + ", '"
                    + model.Nombre + "', '"
                    + model.Aprovado + "', '"
                    + model.Link + "'", con);
                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                con.Close();
                da.Fill(dt);
            }
            return RedirectToAction("SesionesDAIR");
        }

        //CREAR PROPUESTA AIR
        [Route("Home/CrearPropuestaAIR")]
        public ActionResult CrearPropuestaAIR(String SesionAIRId)
        {
            SqlConnection conection = new SqlConnection(ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString);
            conection.Open();
            SqlCommand cmd = new SqlCommand("SELECT * FROM dbo.Etapa;", conection);
            SqlDataAdapter data = new SqlDataAdapter(cmd);
            DataTable datatable = new DataTable();
            conection.Close();
            data.Fill(datatable);
            List<SelectListItem> items = new List<SelectListItem>();
            foreach (DataRow row in datatable.Rows)
            {
                items.Add(new SelectListItem { Text = row["Nombre"].ToString(), Value = row["Id"].ToString() });
            }
            ViewBag.EtapaId = items;
            ViewBag.SesionAIRId = SesionAIRId;
            List<SelectListItem> items_aprovado = new List<SelectListItem>();
            items_aprovado.Add(new SelectListItem { Text = "Sí", Value = "1" });
            items_aprovado.Add(new SelectListItem { Text = "No", Value = "0" });
            ViewBag.Aprovado = items_aprovado;
            return View();
        }

        [HttpPost]
        public ActionResult GuardarNuevaPropuestaAIR(FormCrearPropuestaAIR model)
        {
            if (!ModelState.IsValid)
            {
                SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString);
                con.Open();
                SqlCommand cmd = new SqlCommand("EXEC CreatePropuestaAIR "
                    + model.Id + ", '"
                    + model.EtapaId + "', '"
                    + model.Aprovado + "', '"
                    + model.Nombre + "', '"
                    + model.Link + "', '"
                    + model.NumeroPropuesta + "', '"
                    + model.VotosFavor + "', '"
                    + model.VotosContra + "', '"
                    + model.VotosBlanco + "'", con);
                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                con.Close();
                da.Fill(dt);
            }
            return RedirectToAction("SesionesAIR");
        }
        [HttpPost]
        public ActionResult EnviarEdicionPropuestaDAIR(FormEditarPropuestaDAIR model)
        {
            if (!ModelState.IsValid)
            {
                System.Console.WriteLine("Se tiene la infomacion");
                SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString);
                con.Open();

                SqlCommand cmd = new SqlCommand("EXEC UpdatePropuestaDAIR "
                    + model.Id + ", '"
                    + model.Nombre + "', '"
                    + model.Aprovado + "', '"
                    + model.Link + "'", con);
                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                con.Close();
                da.Fill(dt);
            }
            return RedirectToAction("SesionesDAIR");
        }
        [Route("Home/Constancias")]
        public ActionResult Constancias()
        {
            SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString);
            con.Open();
            SqlCommand cmd = new SqlCommand("EXEC GetAsambleistas", con);
            SqlDataAdapter da = new SqlDataAdapter(cmd);
            DataTable dt = new DataTable();
            con.Close();
            da.Fill(dt);
            return View(dt);

        }
        public ActionResult AsistenciaAIR()
        {
            SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString);
            con.Open();
            SqlCommand cmd = new SqlCommand("EXEC GetSesionesAIR", con);
            SqlDataAdapter da = new SqlDataAdapter(cmd);
            DataTable dt = new DataTable();
            con.Close();
            da.Fill(dt);
            return View(dt);
        }

        public ActionResult AsistenciaSesionAIR(int id)
        {
            SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString);
            con.Open();
            SqlCommand cmd = new SqlCommand($"EXEC GetAsistenciaSesionAIR {id}", con);
            SqlDataAdapter da = new SqlDataAdapter(cmd);
            DataTable dt = new DataTable();
            con.Close();
            da.Fill(dt);
            return View(dt);
        }
    }



}