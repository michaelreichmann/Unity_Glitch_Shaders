using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SpawnCubes : MonoBehaviour
{
    public GameObject cube;
    public int numCubes;
    public float destroyRange;
    public float positionRange;
    public float initiaScale;

    public float scaleFactor;
    public float scaleDuration;


    public void SpawnAndDestroy()
    {
        for (int i = 0; i < numCubes; i++)
        {
            //gameObject as child
            GameObject newCube = Instantiate(cube) as GameObject;
            newCube.transform.SetParent(transform);

            //position
            Vector3 positionOffset = new Vector3(Random.Range(-positionRange, positionRange), Random.Range(-positionRange, positionRange), Random.Range(-positionRange, positionRange));
            newCube.transform.position = transform.position + positionOffset;
            newCube.transform.localScale = new Vector3(initiaScale, initiaScale, initiaScale);

            float destroyDelay = Random.Range(0f, destroyRange);

            //destroy
            Destroy(newCube, destroyDelay);
        }
    }


    //scale up and down
    IEnumerator ScaleUpAndDown(float upScale, float duration, float initialScale)
    {
        for (float time = 0; time < duration * 2; time += Time.deltaTime)
        {
            float progress = Mathf.PingPong(time, duration) / duration;
            float size = Mathf.Lerp(initialScale, upScale, progress);

            Transform[] allChildren = GetComponentsInChildren<Transform>();
            foreach (Transform cube in transform)
            {
                Vector3 scale = new Vector3(size, size, size);

                cube.transform.localScale = scale;
            }

            yield return null;
        }
    }


    public void CubesSize()
    {
        StartCoroutine(ScaleUpAndDown(scaleFactor, scaleDuration, initiaScale));
    }
}
