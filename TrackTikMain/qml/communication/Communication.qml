import QtQuick 2.3

Item {
    id: comm
    signal received(variant jsonObject)
    function getJSON(url, cache) {
        var xhr = new XMLHttpRequest
        url = "http://54.235.241.164/api/" + url
        url = addRequestParams(url)
        xhr.open("GET", url, true)
        xhr.onreadystatechange = function()
        {
            if ( xhr.readyState == xhr.DONE)
            {
                if ( xhr.status == 200)
                {
                    console.log(xhr.responseText);
                    comm.received(JSON.parse(xhr.responseText));
                }
            }
        }

        xhr.send();
    }

    function addRequestParams(url)
    {
        return url + '?' + getRequestParams();
    }

    function getRequestParams()
    {
        return "idaccount=314082&__device_id=817&__geo_accuracy=74&__lat=45.51786&__device_account_id=314082&__rtime=1408298275&__locale=zz&__lon=-73.582855&__device_token=b432a0cf4ba5a18ad4276f48adab80bea738e0e0&__token=87905c3430ec2a80660390741bc68bf1-552&__device_serial=ffffffff-f32c-d515-a12d-ef33729b5c4d&__device_location_id=109";
    }
}
