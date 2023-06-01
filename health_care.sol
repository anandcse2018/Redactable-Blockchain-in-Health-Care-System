// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

contract HealthcareSystem 
{
    struct Patient 
    {
        uint256 id;
        string name;
        string medicalHistory;
        uint256[] treatmentPlanIds;
        uint256 requestedDoctorId;
    }
    
    struct Doctor 
    {
        uint256 id;
        string name;
        string specialization;
        uint256[] patientIds;
        bool flag;
    }
    
    struct Pharmacy 
    {
        uint256 id;
        string name;
        string location;
        uint256[] prescriptionIds;
    }
    
    struct InsuranceCompany 
    {
        uint256 id;
        string name;
        uint256[] patientIds;
    }
    
    struct Payment 
    {
        uint256 id;
        uint256 amount;
        uint256 fromId;
        uint256 toId;
        string description;
        bool isProcessed;
    }
    
    struct TreatmentPlan 
    {
        uint256 id;
        uint256 doctorId;
        uint256 patientId;
        string description;
    }
    
    mapping(uint256 => Patient) public patients;
    mapping(uint256 => Doctor) public doctors;
    mapping(uint256 => Pharmacy) public pharmacies;
    mapping(uint256 => InsuranceCompany) public insuranceCompanies;
    mapping(uint256 => Payment) public payments;
    mapping(uint256 => TreatmentPlan) public treatmentPlans;
    
    function addPatient(uint256 id, string memory name, string memory medicalHistory) public 
    {
        patients[id] = Patient(id, name, medicalHistory, new uint256[](0), 0);
    }
    
    function addDoctor(uint256 id, string memory name, string memory specialization, bool _flag) public 
    {
        doctors[id] = Doctor(id, name, specialization, new uint256[](0), _flag);
    }
    
    function addPharmacy(uint256 id, string memory name, string memory location) public 
    {
        pharmacies[id] = Pharmacy(id, name, location, new uint256[](0));
    }
    
    function addInsuranceCompany(uint256 id, string memory name) public 
    {
        insuranceCompanies[id] = InsuranceCompany(id, name, new uint256[](0));
    }
    
    function addPayment(uint256 id, uint256 amount, uint256 fromId, uint256 toId, string memory description) public 
    {
        payments[id] = Payment(id, amount, fromId, toId, description, false);
    }
    
    function getPatientTreatmentPlan(uint256 patientId, uint256 index) public view returns (uint256) 
    {
        return patients[patientId].treatmentPlanIds[index];
    }
    
    function getDoctorPatient(uint256 doctorId, uint256 index) public view returns (uint256) 
    {
        return doctors[doctorId].patientIds[index];
    }
    
    function getPharmacyPrescription(uint256 pharmacyId, uint256 index) public view returns (uint256) 
    {
        return pharmacies[pharmacyId].prescriptionIds[index];
    }
    
    function getInsurancePatient(uint256 insuranceId, uint256 index) public view returns (uint256) 
    {
        return insuranceCompanies[insuranceId].patientIds[index];
    }
    
    function processPayment(uint256 paymentId) public 
    {
        payments[paymentId].isProcessed = true;
    }
    
    function addPatientToDoctor(uint256 patientId, uint256 doctorId) public 
    {
        require(doctors[doctorId].flag == true, "Doctor is not active.");
        
        doctors[doctorId].patientIds.push(patientId);
    }
    
    function addPrescriptionToPharmacy(uint256 prescriptionId, uint256 pharmacyId) public 
    {
        pharmacies[pharmacyId].prescriptionIds.push(prescriptionId);
    }
    
    function addPatientToInsurance(uint256 patientId, uint256 insuranceId) public 
    {
        insuranceCompanies[insuranceId].patientIds.push(patientId);
    }
    
    function updateMedicalHistory(uint256 patientId, string memory newMedicalHistory) public 
    {
        patients[patientId].medicalHistory = newMedicalHistory;
    }
    
    function requestDoctorByPatient(uint256 patientId, uint256 doctorId) public 
    {
        require(doctors[doctorId].flag == true, "Doctor is not active.");
        patients[patientId].requestedDoctorId = doctorId;
    }
    
    function treatment(uint256 treatmentId, uint256 doctorId, uint256 patientId, string memory description) public 
    {
        require(doctors[doctorId].flag == true, "Doctor is not active.");
        treatmentPlans[treatmentId] = TreatmentPlan(treatmentId, doctorId, patientId, description);
        patients[patientId].treatmentPlanIds.push(treatmentId);
    }
}